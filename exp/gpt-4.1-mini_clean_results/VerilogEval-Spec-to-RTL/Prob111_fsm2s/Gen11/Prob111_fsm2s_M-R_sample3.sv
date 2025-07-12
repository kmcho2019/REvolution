module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0, ON = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: begin
                    state <= (j) ? ON : OFF;
                    out <= 1'b0;
                end
                ON: begin
                    state <= (k) ? OFF : ON;
                    out <= 1'b1;
                end
                default: begin
                    state <= OFF;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule