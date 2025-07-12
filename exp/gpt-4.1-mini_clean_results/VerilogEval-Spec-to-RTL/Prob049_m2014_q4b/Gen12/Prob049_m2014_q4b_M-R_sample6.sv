module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

reg d_ff;

// Capture d on the positive edge of clk
always @(posedge clk) begin
    d_ff <= d;
end

// Asynchronous reset clears output immediately
assign q = ar ? 1'b0 : d_ff;

endmodule