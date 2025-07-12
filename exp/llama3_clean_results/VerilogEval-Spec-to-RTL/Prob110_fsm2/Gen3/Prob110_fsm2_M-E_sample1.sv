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

// Internal state register
reg state;

// Asynchronous reset and synchronous state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `OFF;
    end else begin
        case (state)
            `OFF: state <= j ? `ON : `OFF;
            `ON:  state <= k ? `OFF : `ON;
            default: state <= `OFF; // Default to OFF if state is unknown
        endcase
    end
end

// Output generation
always @(posedge clk) begin
    out <= state;
end

endmodule