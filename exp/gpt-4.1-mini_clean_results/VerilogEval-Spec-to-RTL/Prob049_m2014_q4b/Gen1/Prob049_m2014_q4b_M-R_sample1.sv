module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire reset_n;

assign reset_n = ~ar;

always @(posedge clk) begin
    if (!reset_n)
        q <= 1'b0;
    else
        q <= d;
end

endmodule