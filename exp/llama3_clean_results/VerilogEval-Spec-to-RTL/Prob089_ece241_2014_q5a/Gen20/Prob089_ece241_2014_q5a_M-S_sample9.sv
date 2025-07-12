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
        z <= seen_one ? ~x : x;
        seen_one <= seen_one || x;
    end
end

endmodule