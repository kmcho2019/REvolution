module TopModule (
    input clk,
    input d,
    output reg q
);

always @(clk) begin
    q <= d;
end

endmodule