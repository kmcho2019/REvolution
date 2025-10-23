module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Signal to indicate a potential message start
logic msg_start;

// Counter to track the number of bytes since the last message start
logic [1:0] byte_count, next_byte_count;

// Register to hold the 'done' signal for one cycle
logic done_reg, next_done_reg;

always_comb begin
    next_byte_count = byte_count;
    next_done_reg = done_reg;
    
    // Check if the current byte is a potential message start
    msg_start = in[3];
    
    if (msg_start) begin
        next_byte_count = 1'd1; // Reset byte count to 1 if a new message starts
    end else if (byte_count == 2'd2) begin
        next_done_reg = 1'b1; // Signal done if 3 bytes have been received
    end else if (byte_count > 0 && byte_count < 2'd2) begin
        next_byte_count = byte_count + 1'd1; // Increment byte count
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'd0;
        done_reg <= 1'b0;
    end else begin
        byte_count <= next_byte_count;
        done_reg <= next_done_reg;
    end
end

// Assert 'done' when a complete message has been received
assign done = done_reg;

endmodule