module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states
    reg state;
    localparam STATE_B = 1'b1;
    localparam STATE_A = 1'b0;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
                default: state <= STATE_B;
            endcase
        end
    end

    // Output logic (Moore machine - output depends only on state)
    assign out = (state == STATE_B);

endmodule