module LFSR #(
    parameter WIDTH = 4
) (
    input wire clk,        // 1-bit clock
    input wire rst,        // 1-bit active-high reset
    output reg [WIDTH-1:0] out  // 4-bit output
);

// Feedback calculation: XOR of MSB and second MSB, then inverted
wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

always @(posedge clk) begin
    if (rst) begin
        // Initialize to non-zero value (4'b0001)
        out <= { {(WIDTH-1){1'b0}}, 1'b1 };
    end else begin
        // Shift left and insert feedback at LSB
        out <= { out[WIDTH-2:0], feedback };
    end
end

endmodule