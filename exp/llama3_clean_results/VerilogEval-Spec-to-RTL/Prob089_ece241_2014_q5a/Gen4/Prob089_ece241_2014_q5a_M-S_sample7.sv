module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
        z <= 0;
    end else if (~first_one_seen) begin
        z <= 0;
        if (x) first_one_seen <= 1;
    end else begin
        z <= ~x;
    end
end

endmodule