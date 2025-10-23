module TopModule(
    input  clk,  // clock input
    input  d,   // data input
    output q    // data output
);

reg q_reg; // register to hold the output q
reg d_ff_pos; // positive edge triggered D flip-flop
reg d_ff_neg; // negative edge triggered D flip-flop

always @(posedge clk) begin
    d_ff_pos <= d;
end

always @(negedge clk) begin
    d_ff_neg <= d;
end

assign q = (d_ff_pos == 1'b1) || (d_ff_neg == 1'b1);

endmodule