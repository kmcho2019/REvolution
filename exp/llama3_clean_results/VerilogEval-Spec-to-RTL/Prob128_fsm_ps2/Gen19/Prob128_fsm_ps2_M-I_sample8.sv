module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define a counter to track the number of bytes received
logic [1:0] byte_count, next_byte_count;
logic done_reg, next_done;

always_comb begin
    next_byte_count = byte_count;
    next_done = done_reg;
    
    if (reset) begin
        next_byte_count = 0;
        next_done = 0;
    end else begin
        if (byte_count == 0) begin
            if (in[3]) begin
                next_byte_count = 1; // Start counting bytes
            end
        end else begin
            if (byte_count == 2) begin
                next_byte_count = 0; // Reset byte count after 3 bytes
                next_done = 1; // Assert 'done' when the third byte is received
            end else begin
                next_byte_count = byte_count + 1; // Increment byte count
            end
        end
    end
end

always_ff @(posedge clk) begin
    byte_count <= next_byte_count;
    done_reg <= next_done;
end

assign done = done_reg;

endmodule