module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
reg a_prev = 0;

always @(posedge clk) begin
    a_prev <= a;  // Store previous value of a for edge detection
    
    // State toggles on rising edge of a when b is high
    if (~a_prev & a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic: pass-through when a=0, comparison when a=1
assign q = (~a & b) | (a & (state_reg ^ ~b));
assign state = state_reg;

endmodule