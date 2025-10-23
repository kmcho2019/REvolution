module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b11; // Reset to state B (output 1)
        end else begin
            // Shift in new state based on current state (LSB) and input
            state_shift <= {state_shift[0], 
                           (state_shift[0] & in) | (~state_shift[0] & ~in)};
        end
    end

    assign out = state_shift[0];

endmodule