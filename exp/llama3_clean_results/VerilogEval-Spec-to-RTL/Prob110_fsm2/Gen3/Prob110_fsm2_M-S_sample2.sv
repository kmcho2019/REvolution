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

// Asynchronous reset and synchronous state transitions
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF;
        out <= `OFF;
    end else begin
        case (state)
            `OFF: begin
                state <= j? `ON : `OFF;
                out <= j? `ON : `OFF;
            end
            `ON:  begin
                state <= k? `OFF : `ON;
                out <= k? `OFF : `ON;
            end
            default: begin
                state <= `OFF; // Default to OFF if state is unknown
                out <= `OFF;
            end
        endcase
    end
end

endmodule