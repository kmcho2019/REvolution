module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State parameters for readability
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    // State register (0=B, 1=A)
    reg state;

    // State transitions and reset handling
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Reset to state B (out=1)
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    // Output is directly derived from state (1 when in STATE_B)
    assign out = (state == STATE_B);

endmodule