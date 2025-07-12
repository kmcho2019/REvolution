module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    // Output is 1 when in state B, 0 when in state A
    assign out = (state == STATE_B);

endmodule