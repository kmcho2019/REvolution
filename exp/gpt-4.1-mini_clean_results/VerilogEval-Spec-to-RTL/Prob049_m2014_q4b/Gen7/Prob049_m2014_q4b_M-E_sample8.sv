module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

wire reset_d;

assign reset_d = ar ? 1'b0 : d;

always @(posedge clk) begin
    if (ar)
        q <= 1'b0;  // double check synchronous reset for glitch-free output
    else
        q <= reset_d;
end

endmodule