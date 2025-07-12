module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;

always @(posedge areset) begin
    first_one_seen <= 0;
    z <= 0;
end

always @(posedge clk) begin
    if (~first_one_seen) begin
        if (x) begin
            first_one_seen <= 1;
            z <= 1;
        end else begin
            z <= 0;
        end
    end else begin
        z <= ~x;
    end
end

endmodule