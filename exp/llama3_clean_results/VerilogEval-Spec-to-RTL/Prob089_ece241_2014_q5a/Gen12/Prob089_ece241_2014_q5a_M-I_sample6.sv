module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg seen_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        seen_one <= 0;
        z <= 0;
    end else begin
        if (!seen_one) begin
            z <= x;
            if (x) begin
                seen_one <= 1;
            end
        end else begin
            z <= ~x;
        end
    end
end

endmodule