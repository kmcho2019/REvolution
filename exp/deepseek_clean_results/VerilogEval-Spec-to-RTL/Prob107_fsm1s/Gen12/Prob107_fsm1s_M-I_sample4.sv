module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Reset to state B
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
                default: state <= STATE_B;
            endcase
        end
    end

    // Output logic (Moore)
    assign out = (state == STATE_B);  // out=1 when in state B, out=0 when in state A

endmodule