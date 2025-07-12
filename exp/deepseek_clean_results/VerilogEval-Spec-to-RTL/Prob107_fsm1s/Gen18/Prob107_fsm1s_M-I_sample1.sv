module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Clear state definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;
    reg last_in;
    wire clk_en = (in != last_in) || reset;

    // Clock-gated state transition logic
    always @(posedge clk) begin
        last_in <= in;
        if (reset) begin
            state <= STATE_B;
            out <= 1'b1;
        end else if (clk_en) begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
            out <= (state == STATE_B);
        end
    end

endmodule