module TopModule(
    input clk,
    input d,
    output reg q
);

reg latch_q;
reg reg_q;

// Transparent latch: latch_q follows d when clk=1
always @(*) begin
    if (clk)
        latch_q = d;
    else
        latch_q = latch_q;
end

// Register stage: captures latch_q on negedge clk
always @(negedge clk) begin
    reg_q <= latch_q;
end

// Output driven by the register
always @(posedge clk) begin
    q <= reg_q;
end

endmodule