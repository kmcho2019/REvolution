module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // Reset to state B
        end else begin
            if (~in) begin
                // Circular left shift when in=0
                state_shift <= {state_shift[0], state_shift[1]};
            end
            // When in=1, maintain current state (no change)
        end
    end

    // Output is LSB of shift register
    assign out = state_shift[0];

endmodule