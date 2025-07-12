module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0], q[31:1]} ^ (q[0] ? 32'h80000003 : 32'h0);
    end
end

endmodule