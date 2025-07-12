module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] internal_q;

always @(negedge clk) begin
    if (reset) begin
        internal_q <= 8'h34;
    end else begin
        internal_q <= d;
    end
end

assign q = internal_q;

endmodule