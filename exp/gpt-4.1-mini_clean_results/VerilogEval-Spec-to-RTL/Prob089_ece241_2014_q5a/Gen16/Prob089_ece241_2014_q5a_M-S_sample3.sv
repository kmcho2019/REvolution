module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    reg state;  // 0 = before first 1, 1 = after first 1

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    z <= x;
                    if (x)
                        state <= 1'b1;
                end
                1'b1: begin
                    z <= ~x;
                    state <= 1'b1;
                end
            endcase
        end
    end

endmodule