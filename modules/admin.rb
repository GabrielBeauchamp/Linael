class Modules::Admin < ModuleIRC

Name="admin"

def self.requireAuth?
	true
end

def startMod
	addAuthCmdMethod(self,:join,":join")
	addAuthCmdMethod(self,:part,":part")
	addAuthCmdMethod(self,:kick,":kick")
	addAuthCmdMethod(self,:quickKick,":quickKick")
	addAuthCmdMethod(self,:die,":die")
end

def endMod
	delAuthMethod(self,":join")
	delAuthMethod(self,":part")
	delAuthMethod(self,":kick")
	delAuthMethod(self,":quickKick")
	delAuthMethod(self,":die")
end

def join privMsg
	if (module? privMsg) &&
		(join? privMsg)
		if privMsg.message =~ /^!admin\sjoin\s(#[\S]*)/
			answer(privMsg,"Oki doki! i'll join #{$~[1]}")	
			join_channel $~[1]
		end
	end
end

def part privMsg
	if (module? privMsg) &&
		(part? privMsg)
		if privMsg.message =~ /^!admin\spart\s(#[\S]*)/
			answer(privMsg,"Oki doki! i'll part #{$~[1]}")	
			talk($~[1],"cya all!")
			part_channel $~[1]
		end
	end


end

def die privMsg
	if (module? privMsg) &&
		(die? privMsg)

		answer(privMsg,"Oh... Ok... I'll miss you")
		quit_channel "I'll miss you!"
		exit 0
	end

end

def mode privMsg

end

def quickKick privMsg
	if (quickKick? privMsg)
		
		if privMsg.message =~ /^!k\s(#\S*)\s(\S*)\s(.*)/
			where=$~[1]
			who=$~[2]
			message=$~[3]
		end
		if privMsg.message =~ /^!k\s([^\s#]*)\s(.*)/
			return if privMsg.private_message?
			where=privMsg.place
			who=$~[1]
			message=$~[2]
		end
		if privMsg.message =~ /^!k\s(#\S*)\s(\S*)[^\S]$/
			where=$~[1]
			who=$~[2]
			message=$~[2]
		end
		if privMsg.message =~ /^!k\s([^\s#]*)[^\S]$/
			return if privMsg.private_message?
			where=privMsg.place
			who=$~[1]
			message=$~[1]
		end
		return if !(defined? who)
		answer(privMsg,"Oki doki! i'll kick #{who} on #{where}")	
		talk(where,"bye #{who}!")
		kick_channel(where,who,message)
	end
end

def quickKick? privMsg
	privMsg.message =~ /^!k\s/
end

def kick privMsg
	if (module? privMsg) &&
		(kick? privMsg)
		if (privMsg.message =~ /^!admin\skick\s(#\S*)\s(\S*)\s(.*)$/)
			where=$~[1]
			who=$~[2]
			message=$~[3]
		else
			if privMsg.message =~ /^!admin\skick\s([^#\s]*)\s(.*)$/
				return if privMsg.private_message?
				where=privMsg.place
				who=$~[1]
				message=$~[2]
			else
				if privMsg.message =~ /^!admin\skick\s(#\S*)\s(\S*)/
					where =$~[1]
					who=$~[2]
					message=who
				else
					if privMsg.message =~ /^!admin\skick\s([^#\s]*)/
						return if privMsg.private_message?
						where=privMsg.place
						who=$~[1]
						message=who
					else
						return
					end
				end
			end
		end
		answer(privMsg,"Oki doki! i'll kick #{who} on #{where}")	
		talk(where,"bye #{who}!")
		kick_channel(where,who,message)
	end
	
end

def knockout

end

def module? privMsg
	privMsg.message.match '^!admin\s'
end

def join? privMsg
	privMsg.message.match '^!admin\sjoin\s'
end

def part? privMsg
	privMsg.message.match '^!admin\spart\s'
end

def kick? privMsg
	privMsg.message.match '^!admin\skick\s'
end

def die? privMsg
	privMsg.message.match '^!admin\sdie'
end

end
