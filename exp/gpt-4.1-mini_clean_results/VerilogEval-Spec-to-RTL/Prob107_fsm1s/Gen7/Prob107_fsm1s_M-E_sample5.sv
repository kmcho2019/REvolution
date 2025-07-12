module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Sequential block: state and output update synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for state B
        end else begin
            // Next state logic
            case (state)
                B: next_state = (in == 1'b0) ? A : B;
                A: next_state = (in == 1'b0) ? B : A;
                default: next_state = B;
            endcase
            
            state <= next_state;

            // Output logic depends only on next state (Moore)
            // Output is registered, so output changes after state update
            out <= (next_state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule