module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state logic inside clocked block
always @(posedge clk) begin
    if (a & b)
        state <= ~state;       // Toggle
    else if (~a & b)
        state <= 1'b1;         // Set
    else if (a & ~b)
        state <= 1'b0;         // Reset
    else
        state <= state;        // Hold
end

// Output q combinational logic
assign q = (a & b)      ? ~state :
           (~a & b)     ? 1'b1  :
           (a & ~b)     ? 1'b0  :
                          state;

// Initialize state to 0 for simulation
initial state = 1'b0;

endmodule