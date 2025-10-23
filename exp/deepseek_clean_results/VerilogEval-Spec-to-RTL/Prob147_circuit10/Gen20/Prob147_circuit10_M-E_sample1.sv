module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
reg a_prev, b_prev;

// Edge detection registers
always @(posedge clk) begin
    a_prev <= a;
    b_prev <= b;
end

// Detect rising edge of a while b is high
wire a_rise = a & ~a_prev;
wire pattern_detected = a_rise & b;

// State transition logic
always @(posedge clk) begin
    if (pattern_detected)
        state_reg <= ~state_reg;
    else if (~a & ~b)
        state_reg <= 0;
end

// Output logic - different behavior based on state
assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule