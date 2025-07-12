module LFSR #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    input wire enable,    // Optional clock gating control
    output reg [WIDTH-1:0] out
);

wire feedback;

// Explicit feedback calculation
assign feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

always @(posedge clk) begin
    if (rst) begin
        out <= {{(WIDTH-1){1'b0}}, 1'b1};  // Initialize to 1 at LSB
    end
    else if (enable) begin
        out <= {out[WIDTH-2:0], feedback};  // Shift and insert feedback
    end
end

endmodule