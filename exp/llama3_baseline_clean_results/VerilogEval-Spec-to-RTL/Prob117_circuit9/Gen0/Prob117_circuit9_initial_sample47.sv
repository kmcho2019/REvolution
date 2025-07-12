module TopModule(clk, a, q);
input clk, a;
output [2:0] q;
reg [2:0] q;

always @(posedge clk) begin
    if (a == 1) begin
        if (q == 0) begin
            q <= 4;
        end
        else begin
            q <= q;
        end
    end
    else if (a == 0) begin
        if (q == 7) begin
            q <= 0;
        end
        else begin
            q <= q + 1;
        end
    end
end
endmodule