module TopModule (
    input clk,
    input a,
    output reg q
);

reg cleared;

initial begin
    q = 1'b0;
    cleared = 1'b0;
end

always @(posedge clk) begin
    if (!cleared) begin
        if (a) begin
            q <= 1'b0;
            cleared <= 1'b1;
        end
        else begin
            q <= 1'b1;
        end
    end
end

endmodule