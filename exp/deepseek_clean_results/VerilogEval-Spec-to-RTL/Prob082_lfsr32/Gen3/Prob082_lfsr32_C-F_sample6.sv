module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];
localparam [31:0] TAP_MASK = 32'h80040003;  // Taps at bits 32,22,2,1 (1-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {1'b0, q[31:1]} ^ (TAP_MASK & {32{feedback}});
    end
end

endmodule