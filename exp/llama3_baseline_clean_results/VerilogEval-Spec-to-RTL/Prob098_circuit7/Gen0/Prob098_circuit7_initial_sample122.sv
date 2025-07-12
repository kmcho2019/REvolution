module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        if (!q) begin
            q <= 1;
        end
    end
end

endmodule