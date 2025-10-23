module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    // Shift register implementation
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b10; // Reset to state B
        end else begin
            case (state_shift[1])
                1'b1: state_shift <= {state_shift[0], in};    // State B transition
                1'b0: state_shift <= {state_shift[0], ~in};   // State A transition
            endcase
        end
    end

    // Output is MSB of shift register
    assign out = state_shift[1];

endmodule