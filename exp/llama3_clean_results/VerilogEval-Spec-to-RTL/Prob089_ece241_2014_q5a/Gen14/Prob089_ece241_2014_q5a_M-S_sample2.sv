module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg invert;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        invert <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~invert) begin
            if (x) begin
                invert <= 1'b1;
            end
            z <= x;
        end else begin
            z <= ~x;
        end
    end
end

endmodule