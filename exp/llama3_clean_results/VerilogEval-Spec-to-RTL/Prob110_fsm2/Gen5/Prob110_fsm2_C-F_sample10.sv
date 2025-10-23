// Define the states as binary values
`define OFF 1'b0
`define ON  1'b1

module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state
reg next_state; // next state

// Asynchronous reset and synchronous state transitions
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF;
    end else begin
        case (state)
            `OFF: state <= j? `ON : `OFF;
            `ON:  state <= k? `OFF : `ON;
            default: state <= `OFF; // Default to OFF if state is unknown
        endcase
    end
end

// Directly assign output based on state
assign out = state;

endmodule