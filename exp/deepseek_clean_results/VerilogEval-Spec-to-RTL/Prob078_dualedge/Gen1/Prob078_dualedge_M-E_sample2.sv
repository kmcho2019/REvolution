module TopModule (
    input clk,
    input d,
    output reg q
);

reg virtual_clk = 0;

always @(posedge clk or negedge clk) begin
    virtual_clk <= ~virtual_clk;
end

always @(posedge virtual_clk) begin
    q <= d;
end

endmodule