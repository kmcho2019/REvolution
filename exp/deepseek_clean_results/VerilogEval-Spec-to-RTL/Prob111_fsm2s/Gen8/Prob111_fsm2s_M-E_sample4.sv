module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state_shift;  // Shift register implementation
    wire next_bit;

    // Next bit calculation:
    // When in OFF (01), next bit is j
    // When in ON (10), next bit is ~k
    assign next_bit = state_shift[0] ? ~k : j;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // Initialize to OFF state
        end else begin
            state_shift <= {next_bit, state_shift[1]};  // Shift in new bit
        end
    end

    // Output is the current state (LSB of shift register)
    assign out = state_shift[0];

endmodule