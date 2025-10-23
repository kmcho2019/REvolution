module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to state B
        end else begin
            // Shift left or right based on input
            if (in) begin
                state <= {state[0], state[1]};  // Hold pattern for in=1
            end else begin
                state <= {~state[0], state[1]}; // Swap bits for in=0
            end
        end
    end

    // Output is MSB (state A=10->0, state B=01->1)
    // Also corrects any invalid states (00 or 11) to valid output
    assign out = ~state[1] | ~state[0];

endmodule