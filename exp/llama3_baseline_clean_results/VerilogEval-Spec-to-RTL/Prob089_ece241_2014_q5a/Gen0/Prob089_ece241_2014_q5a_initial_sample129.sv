module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg complementing = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        complementing <= 0;
        z <= 0;
    end else if (complementing == 0) begin
        if (x == 1) begin
            complementing <= 1;
            z <= 1;
        end else begin
            z <= 0;
        end
    end else begin
        z <= ~x;
    end
end

endmodule