module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg state; // 0 = OFF, 1 = ON

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // OFF state
            out <= 1'b0;
        end else begin
            case(state)
                1'b0: begin // OFF
                    if (j)
                        state <= 1'b1; // ON
                    else
                        state <= 1'b0;
                    out <= 1'b0;
                end
                1'b1: begin // ON
                    if (k)
                        state <= 1'b0; // OFF
                    else
                        state <= 1'b1;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule