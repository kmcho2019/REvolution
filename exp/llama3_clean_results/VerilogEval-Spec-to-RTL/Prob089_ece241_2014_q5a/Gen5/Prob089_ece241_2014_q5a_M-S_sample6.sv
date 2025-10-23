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
    end else begin
        if (~first_one_seen && x) first_one_seen <= 1;
        z <= first_one_seen ? ~x : 0;
    end
end

endmodule