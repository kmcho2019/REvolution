// Define the states as enumerations
parameter OFF = 1'b0;
parameter ON  = 1'b1;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg state; // Current state

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
            default: state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = state;

endmodule