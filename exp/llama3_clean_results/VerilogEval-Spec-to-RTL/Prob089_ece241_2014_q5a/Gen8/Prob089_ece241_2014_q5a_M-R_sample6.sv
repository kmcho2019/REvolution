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
    end else begin
        if (x && !first_one) begin
            first_one <= 1;
        end
    end
end

assign z = (first_one) ? ~x : x;

endmodule