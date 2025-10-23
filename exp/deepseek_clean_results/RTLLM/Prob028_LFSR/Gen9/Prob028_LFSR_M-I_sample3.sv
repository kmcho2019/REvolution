module LFSR #(
    parameter WIDTH = 4
) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// Feedback calculation (XOR of bits 3 and 2 with inversion as specified)
wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= {WIDTH{1'b0}};  // Active high reset
    end else begin
        // Shift left and insert inverted feedback at LSB
        out <= {out[WIDTH-2:0], feedback};
    end
end

endmodule