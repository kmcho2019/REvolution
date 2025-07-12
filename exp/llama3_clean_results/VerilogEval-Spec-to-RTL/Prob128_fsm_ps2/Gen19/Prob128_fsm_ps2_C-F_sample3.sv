module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define a counter to track the number of bytes received
logic [1:0] byte_count, next_byte_count;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_byte_count = byte_count;
    next_msg_received = 0;
    
    if (byte_count == 0) begin
        if (in[3]) begin
            next_byte_count = 1; // Start counting bytes
        end
    end else begin
        next_byte_count = byte_count + 1; // Increment byte count
        if (next_byte_count == 3) begin
            next_byte_count = 0; // Reset byte count after 3 bytes
            next_msg_received = 1; // Set msg_received flag
        end
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
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule