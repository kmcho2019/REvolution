module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one <= 0;
        z <= 0;
    end else begin
        if (x && !first_one) begin
            first_one <= 1;
            z <= 1;
        end else if (first_one) begin
            z <= ~x;
        end else begin
            z <= x;
        end
    end
end

endmodule