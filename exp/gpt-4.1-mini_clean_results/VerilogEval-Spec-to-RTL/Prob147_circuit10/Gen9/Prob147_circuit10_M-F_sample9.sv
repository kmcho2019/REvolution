module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // Next state: toggle state if b=1 and a != state, else hold state
    next_state = (b & (a ^ state)) | (~b & state);
    
    // Output q: set when both a and b are 1, or when state is 1 and b is 0
    q = (b & a) | (state & ~b);
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule