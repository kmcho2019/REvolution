module TopModule (
    input clk,
    input d,
    output q
);

reg q_ff;    // Rising edge flip-flop
reg q_latch; // Transparent latch

// Flip-flop triggered on rising edge of clk
always @(posedge clk) begin
    q_ff <= d;
end

// Latch transparent when clk is low
always @(*) begin
    if (~clk)
        q_latch = d;
    else
        q_latch = q_latch; // Hold value when clk is high
end

// Output mux selects flip-flop output when clk is high, latch output when clk is low
assign q = clk ? q_ff : q_latch;

endmodule