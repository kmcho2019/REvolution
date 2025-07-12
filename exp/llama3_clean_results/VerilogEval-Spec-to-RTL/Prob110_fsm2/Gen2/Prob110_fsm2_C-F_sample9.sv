// Define the states as enumerations for better readability
`define OFF 1'b0
`define ON  1'b1

module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // 1-bit signal to represent the current state

// Combine state transitions and output logic within a single always block
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF; // Reset to OFF state
        out <= `OFF;   // Directly assign output to OFF during reset
    end else begin
        case (state)
            `OFF: begin
                state <= j? `ON : `OFF; // Transition from OFF to ON based on j
                out <= j? `ON : `OFF;   // Update output based on next state
            end
            `ON: begin
                state <= k? `OFF : `ON; // Transition from ON to OFF based on k
                out <= k? `OFF : `ON;   // Update output based on next state
            end
            default: begin
                state <= `OFF; // Default to OFF if state is unknown
                out <= `OFF;   // Assign output to OFF for unknown state
            end
        endcase
    end
end

endmodule