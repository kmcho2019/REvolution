// Define the states as parameters
parameter OFF = 1'b0;
parameter ON  = 1'b1;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg state; // current state

// SR-Latch implementation
always @(*) begin
    if (areset) begin
        state = OFF;
    end else if (~clk) begin // latch is transparent when clk is low
        if (state == OFF && j) begin
            state = ON;
        end else if (state == ON && k) begin
            state = OFF;
        end
    end
end

// Output logic directly from state
assign out = state;

endmodule