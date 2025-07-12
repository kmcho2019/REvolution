module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);

parameter RESET_VAL = 0;

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

localparam RESET_VECTOR = 8'h34;

// Instantiate 8 DFFs with parameterized reset values
DFF #(.RESET_VAL(RESET_VECTOR[7])) dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));
DFF #(.RESET_VAL(RESET_VECTOR[6])) dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
DFF #(.RESET_VAL(RESET_VECTOR[5])) dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
DFF #(.RESET_VAL(RESET_VECTOR[4])) dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
DFF #(.RESET_VAL(RESET_VECTOR[3])) dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
DFF #(.RESET_VAL(RESET_VECTOR[2])) dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
DFF #(.RESET_VAL(RESET_VECTOR[1])) dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
DFF #(.RESET_VAL(RESET_VECTOR[0])) dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));

endmodule