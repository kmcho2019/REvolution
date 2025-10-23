module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // COPY state
                    z <= x;
                    if (x) state <= 1'b1;
                end
                1'b1: begin // INVERT state
                    z <= ~x;
                end
            endcase
        end
    end

endmodule