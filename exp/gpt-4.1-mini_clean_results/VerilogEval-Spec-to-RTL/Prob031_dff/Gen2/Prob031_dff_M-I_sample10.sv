module TopModule (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (d != q) begin
            q <= d;
        end
    end
endmodule