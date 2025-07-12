module TopModule (
    input clk,
    input d,
    input q
);

reg out_q; // Register to store the output

always @(posedge clk) begin
    if (q) begin
        out_q <= d;
    end
end

// To avoid a latch and make the output a continuous assignment,
// we can use an assign statement if 'q' does not influence the clock.
assign TopModule_out_q = out_q;

endmodule