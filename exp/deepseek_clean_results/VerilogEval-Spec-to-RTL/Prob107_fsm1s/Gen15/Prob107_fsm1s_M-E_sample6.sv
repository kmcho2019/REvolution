module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state_bit;  // Acts as both storage and state indicator

    // Feedback logic for shift register
    wire next_bit = state_bit ? (state_bit ^ in) : in;

    always @(posedge clk) begin
        if (reset) begin
            state_bit <= 1'b0;  // Reset to state B (0)
        end else begin
            state_bit <= next_bit;
        end
    end

    // Output mapping (B=1, A=0)
    assign out = ~state_bit;

endmodule