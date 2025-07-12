module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg state; // current state

// Next state logic using combinational gates
wire next_state = (state && ~k) || (~state && j);

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Output assignment
assign out = state;

endmodule