module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Counter to track the number of bytes received
logic [1:0] byte_count, next_byte_count;

// Flag to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_byte_count = byte_count;
    next_msg_received = 0;
    
    if(in[3] && byte_count == 0) begin
        // Start counting when the first byte of a message is detected
        next_byte_count = 1;
    end
    else if(byte_count > 0) begin
        // Increment the counter for each subsequent byte
        next_byte_count = byte_count + 1;
        
        if(byte_count == 2) begin
            // Set msg_received flag when a complete message is received
            next_msg_received = 1;
        end
    end
    else if(reset) begin
        // Reset the counter and msg_received flag when reset is active high
        next_byte_count = 0;
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
        msg_received <= 0;
    end
    else begin
        byte_count <= next_byte_count;
        msg_received <= next_msg_received;
        
        if(msg_received) begin
            // Reset the counter after a message is fully received
            byte_count <= 0;
        end
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule