module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    
    // Calculate feedback as XOR of bits 3 and 2 (no inversion here)
    assign feedback = out[3] ^ out[2];

    always @(posedge clk) begin
        if (rst) 
            out <= 4'b0110; // Different non-zero seed on reset
        else begin
            // Shift left by one and insert inverted feedback at LSB
            out <= {out[2:0], ~feedback};
        end
    end

endmodule