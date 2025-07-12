module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    reg state; // 0 = COPY, 1 = INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // COPY
            z <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                z <= x;
                if (x)
                    state <= 1'b1; // switch to INVERT
            end else begin
                z <= ~x;
            end
        end
    end

endmodule