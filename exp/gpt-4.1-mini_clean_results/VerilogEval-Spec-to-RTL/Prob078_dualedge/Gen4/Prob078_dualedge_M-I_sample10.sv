module TopModule (
    input clk,
    input d,
    output q
);

reg q_ff;    // flip-flop output (posedge clk)
reg q_latch; // latch output (transparent when clk=0)

always @(posedge clk) begin
    q_ff <= d;
end

always @(*) begin
    if (~clk)
        q_latch = d;  // transparent latch when clk is low
    else
        q_latch = q_latch; // hold value when clk is high
end

assign q = clk ? q_ff : q_latch;

endmodule