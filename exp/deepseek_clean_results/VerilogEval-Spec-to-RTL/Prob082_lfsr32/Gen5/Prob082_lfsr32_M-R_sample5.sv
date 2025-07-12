module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

parameter TAP_MASK = 32'h80040003;  // Bits 31, 21, 1, and 0 (0-based)
wire feedback = q[0];
wire [31:0] next_q = (reset) ? 32'h1 : 
                    ({1'b0, q[31:1]} ^ (feedback ? TAP_MASK : 32'b0));

always @(posedge clk) begin
    q <= next_q;
end

endmodule