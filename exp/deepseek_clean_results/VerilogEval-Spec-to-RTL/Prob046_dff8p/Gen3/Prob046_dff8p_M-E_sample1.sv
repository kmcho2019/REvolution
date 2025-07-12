module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Individual D flip-flop module with negative edge trigger
module DFF_NEG (
    input clk,
    input reset,
    input reset_val,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset) begin
            q <= reset_val;
        end else begin
            q <= d;
        end
    end
endmodule

// Instantiate 8 DFFs with specific reset values (0x34 = 00110100)
DFF_NEG dff7 (.clk(clk), .reset(reset), .reset_val(1'b0), .d(d[7]), .q(q[7]));
DFF_NEG dff6 (.clk(clk), .reset(reset), .reset_val(1'b0), .d(d[6]), .q(q[6]));
DFF_NEG dff5 (.clk(clk), .reset(reset), .reset_val(1'b1), .d(d[5]), .q(q[5]));
DFF_NEG dff4 (.clk(clk), .reset(reset), .reset_val(1'b1), .d(d[4]), .q(q[4]));
DFF_NEG dff3 (.clk(clk), .reset(reset), .reset_val(1'b0), .d(d[3]), .q(q[3]));
DFF_NEG dff2 (.clk(clk), .reset(reset), .reset_val(1'b1), .d(d[2]), .q(q[2]));
DFF_NEG dff1 (.clk(clk), .reset(reset), .reset_val(1'b0), .d(d[1]), .q(q[1]));
DFF_NEG dff0 (.clk(clk), .reset(reset), .reset_val(1'b0), .d(d[0]), .q(q[0]));

endmodule