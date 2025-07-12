module TopModule(
    input clk,
    input d,
    input q
);

reg out_q;

always @(posedge clk) begin
    if (q) begin
        out_q <= 1'b0; // active high reset
    end else begin
        out_q <= d;
    end
end

// since 'q' is an input, we cannot directly assign it. Instead, we'll use 'out_q' as our output
assign q = out_q;

endmodule