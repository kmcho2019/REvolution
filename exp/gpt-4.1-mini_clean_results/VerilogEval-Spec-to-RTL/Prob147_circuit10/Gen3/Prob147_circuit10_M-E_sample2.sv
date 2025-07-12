module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational output logic
assign q = (state & a) | (~state & b);

always @(*) begin
    if (a & b)
        next_state = ~state;    // toggle
    else if (~a & b)
        next_state = 1'b1;     // set
    else if (~a & ~b)
        next_state = 1'b0;     // reset
    else
        next_state = state;    // hold
end

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule