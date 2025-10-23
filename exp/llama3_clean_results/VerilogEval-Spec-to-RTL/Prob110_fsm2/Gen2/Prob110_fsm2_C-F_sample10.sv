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
        if (state == `OFF) begin // Currently in OFF state
            if (j) begin
                state <= `ON; // Transition to ON state if j=1
            end else begin
                state <= `OFF; // Stay in OFF state if j=0
            end
        end else begin // Currently in ON state
            if (k) begin
                state <= `OFF; // Transition to OFF state if k=1
            end else begin
                state <= `ON; // Stay in ON state if k=0
            end
        end
    end
end

// Output logic directly from state
assign out = state;

endmodule