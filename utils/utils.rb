def handle_error(e)
    status 500
    puts e.message
    puts e.backtrace
    return e.record.errors.full_messages.join(', ')
end