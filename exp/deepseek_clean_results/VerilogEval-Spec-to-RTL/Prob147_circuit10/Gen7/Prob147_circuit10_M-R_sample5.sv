module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire a_rise;
reg state_reg = 0;
reg a_prev = 0;

// Edge detection
assign a_rise = ~a_prev & a;

// Sequential logic using continuous assignment
always @(posedge clk) begin
    a_prev <= a;
    state_reg <= (a_rise & b) ? ~state_reg : state_reg;
end

// Output logic
assign q = a ? (state_reg ^ ~b) : b;
assign state = state_reg;

endmodule