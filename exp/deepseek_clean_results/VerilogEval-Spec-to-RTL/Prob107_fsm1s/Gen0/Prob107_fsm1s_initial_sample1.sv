module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // Current state register

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
                default: state <= STATE_B;
            endcase
        end
    end

    // Output logic (Moore machine: output depends only on state)
    assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule