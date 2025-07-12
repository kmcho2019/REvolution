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
    end else if (x &&!seen_one) begin
        seen_one <= 1;
    end
end

assign z = (seen_one)? ~x : x;

endmodule