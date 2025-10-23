module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states (1'b1 for B, 1'b0 for A)
    parameter STATE_A = 1'b0;
    parameter STATE_B = 1'b1;

    reg state;  // Current state register

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
            endcase
        end
    end

    // Output logic - direct mapping (Moore machine)
    assign out = state;  // STATE_B=1 (out=1), STATE_A=0 (out=0)

endmodule