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
            state <= 1'b0;
            out <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    if (j) begin
                        state <= 1'b1;
                        out <= 1'b1;
                    end else begin
                        state <= 1'b0;
                        out <= 1'b0;
                    end
                end
                1'b1: begin
                    if (k) begin
                        state <= 1'b0;
                        out <= 1'b0;
                    end else begin
                        state <= 1'b1;
                        out <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule