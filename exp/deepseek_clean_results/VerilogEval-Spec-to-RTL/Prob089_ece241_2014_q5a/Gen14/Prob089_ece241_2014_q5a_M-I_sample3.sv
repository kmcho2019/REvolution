module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state; // 0: COPY, 1: INVERT

    assign z = state ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            if (state == 0)
                state <= x;
        end
    end

endmodule