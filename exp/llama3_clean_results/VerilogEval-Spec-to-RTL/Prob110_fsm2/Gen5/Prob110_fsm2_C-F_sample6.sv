module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

// Define states as parameters for flexibility
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Current state register
reg state; // current state

// Asynchronous reset and synchronous state transitions
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
            default: state <= OFF; // Default to OFF if state is unknown
        endcase
    end
end

// Directly assign output based on state for simplicity and efficiency
assign out = state;

endmodule