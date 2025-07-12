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
        end
        z <= first_one ? ~x : x;
    end
end

endmodule