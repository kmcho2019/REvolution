module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
            out <= 1'b1;
        end else begin
            case (state)
                STATE_B: begin
                    state <= in ? STATE_B : STATE_A;
                    out <= 1'b1;
                end
                STATE_A: begin
                    state <= in ? STATE_A : STATE_B;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule