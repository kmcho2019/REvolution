module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 0) begin
        q <= q + 1;
        if (q == 7) begin
            q <= 0;
        end
    end else if (q == 0) begin
        q <= 4;
    end
end

endmodule