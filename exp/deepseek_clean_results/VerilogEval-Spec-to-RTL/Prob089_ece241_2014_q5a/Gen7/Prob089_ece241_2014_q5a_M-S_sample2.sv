module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state;  // 0 = pass, 1 = invert

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else begin
            if (state) begin
                z <= ~x;
            end else begin
                z <= x;
                if (x) state <= 1;
            end
        end
    end

endmodule