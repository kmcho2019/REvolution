module DFF_neg #(
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

localparam RESET_VAL = 8'h34;  // Binary: 00110100

// Instantiate 8 negative-edge triggered DFFs with parameterized reset values
DFF_neg #(.RESET_VAL(RESET_VAL[7])) dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));
DFF_neg #(.RESET_VAL(RESET_VAL[6])) dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
DFF_neg #(.RESET_VAL(RESET_VAL[5])) dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
DFF_neg #(.RESET_VAL(RESET_VAL[4])) dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
DFF_neg #(.RESET_VAL(RESET_VAL[3])) dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
DFF_neg #(.RESET_VAL(RESET_VAL[2])) dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
DFF_neg #(.RESET_VAL(RESET_VAL[1])) dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
DFF_neg #(.RESET_VAL(RESET_VAL[0])) dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));

endmodule