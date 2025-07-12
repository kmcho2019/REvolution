// Define the states as enumerations
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

// Asynchronous reset and synchronous next-state logic
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF;
    end else begin
        // Synchronous next-state logic
        case (state)
            `OFF: state <= j? `ON : `OFF;
            `ON:  state <= k? `OFF : `ON;
            default: state <= `OFF;
        endcase
    end
end

// Output logic directly from state
assign out = state;

endmodule