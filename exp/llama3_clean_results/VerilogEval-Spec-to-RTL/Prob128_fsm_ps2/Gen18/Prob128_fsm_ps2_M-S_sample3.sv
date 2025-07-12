module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define a counter to track the number of bytes received
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_byte_count = byte_count;
    
    if (byte_count == 0) begin
        if (in[3]) begin
            next_byte_count = 1; // Start counting bytes
        end
    end else begin
        next_byte_count = byte_count + 1; // Increment byte count
        if (next_byte_count == 3) begin
            next_byte_count = 0; // Reset byte count after 3 bytes
        end
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
        done <= 0;
    end
    else begin
        byte_count <= next_byte_count;
        // Assert 'done' when the third byte is received
        done <= (byte_count == 2); // Changed from 3 to 2 to signal done one cycle after the third byte
    end
end

endmodule