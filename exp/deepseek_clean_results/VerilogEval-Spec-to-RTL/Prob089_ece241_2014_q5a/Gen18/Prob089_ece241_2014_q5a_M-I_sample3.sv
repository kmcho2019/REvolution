module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state; // 0: COPY, 1: INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else if (!state) begin
            state <= x;
        end
    end

    assign z = state ? ~x : x;

endmodule