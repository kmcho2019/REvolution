module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg state;  // 0: normal, 1: invert
reg [31:0] sum;  // accumulated sum

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        sum <= 0;
    end else begin
        if (state == 0) begin
            if (x == 1) begin
                state <= 1;
                sum <= 0;
            end else begin
                sum <= sum + 1;
            end
        end else begin
            z <= ~x;
        end
    end
end

always @(posedge clk) begin
    if (state == 0) begin
        z <= x;
    end
end

endmodule