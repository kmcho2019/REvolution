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

always_comb begin
    next_byte_count = byte_count;
    next_msg_in_progress = msg_in_progress;
    
    if(in[3]) begin
        next_byte_count = 1; // Reset counter and start a new message
        next_msg_in_progress = 1;
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

// Assert 'done' when a complete message has been received
assign done = (byte_count == 3) && msg_in_progress;

endmodule