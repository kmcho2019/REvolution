module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input clk_enable,  // Added clock enable signal
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk) begin
    if (clk_enable) begin  // Only trigger the flip-flops when clock enable is high
        if (reset) q <= '0;
        else q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic clk_enable;  // Added clock enable signal

// Clock tree optimization: use a buffer to drive the clock signal
buf clk_buf(clk, clk_buf_out);
assign clk_enable = 1'b1;  // Always enable the clock for this example

DFF #(.WIDTH(8)) dff(
  .clk(clk_buf_out),
  .clk_enable(clk_enable),
  .reset(reset),
  .d(d),
  .q(q)
);

endmodule