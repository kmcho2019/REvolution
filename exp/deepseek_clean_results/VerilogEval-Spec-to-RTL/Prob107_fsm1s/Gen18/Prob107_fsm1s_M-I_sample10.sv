module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;
    reg last_in;
    wire clk_enable = (in != last_in); // Clock enable when input changes

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
            out <= 1'b1;
            last_in <= 1'b0;
        end else if (clk_enable) begin
            last_in <= in;
            case (state)
                STATE_B: begin
                    state <= in ? STATE_B : STATE_A;
                    out <= ~(in ? STATE_B : STATE_A);
                end
                STATE_A: begin
                    state <= in ? STATE_A : STATE_B;
                    out <= ~(in ? STATE_A : STATE_B);
                end
            endcase
        end
    end

endmodule