module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Counter to track the number of bytes received since the last message detection
logic [1:0] byte_count, next_byte_count;

// Signal to track whether a message is currently being received
logic msg_in_progress, next_msg_in_progress;

// Signal to track whether the next byte is the start of a new message
logic new_msg_detected, next_new_msg_detected;

always_comb begin
    next_byte_count = byte_count;
    next_msg_in_progress = msg_in_progress;
    next_new_msg_detected = 0;
    
    if(reset) begin
        next_byte_count = 0;
        next_msg_in_progress = 0;
    end
    else if(in[3]) begin
        next_byte_count = 1; // Reset counter and start a new message
        next_msg_in_progress = 1;
        next_new_msg_detected = 1;
    end
    else if(msg_in_progress) begin
        next_byte_count = byte_count + 1; // Increment counter for each byte received
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
        msg_in_progress <= 0;
    end
    else begin
        byte_count <= next_byte_count;
        msg_in_progress <= next_msg_in_progress;
    end
end

// Assert 'done' when a complete message has been received and the next byte is not the start of a new message
assign done = (byte_count == 3) && !in[3];

endmodule