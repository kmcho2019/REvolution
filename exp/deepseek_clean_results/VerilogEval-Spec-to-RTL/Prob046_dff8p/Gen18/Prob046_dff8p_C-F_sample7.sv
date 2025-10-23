module NegEdgeDFF #(
    parameter RESET_VAL = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Reset value 0x34 = binary 00110100
NegEdgeDFF #(.RESET_VAL(1'b0)) dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));  // MSB
NegEdgeDFF #(.RESET_VAL(1'b0)) dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
NegEdgeDFF #(.RESET_VAL(1'b1)) dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
NegEdgeDFF #(.RESET_VAL(1'b1)) dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
NegEdgeDFF #(.RESET_VAL(1'b0)) dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
NegEdgeDFF #(.RESET_VAL(1'b1)) dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
NegEdgeDFF #(.RESET_VAL(1'b0)) dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
NegEdgeDFF #(.RESET_VAL(1'b0)) dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));  // LSB

endmodule