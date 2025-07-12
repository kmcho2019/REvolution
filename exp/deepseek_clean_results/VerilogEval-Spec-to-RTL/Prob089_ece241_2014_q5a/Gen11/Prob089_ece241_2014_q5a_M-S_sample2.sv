module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin
                    z <= x;
                    if (x) state <= 1;
                end
                1: z <= ~x;
            endcase
        end
    end

endmodule