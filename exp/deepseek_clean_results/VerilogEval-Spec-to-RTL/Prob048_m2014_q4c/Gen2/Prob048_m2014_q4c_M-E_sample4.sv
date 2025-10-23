module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_d = r ? 1'b0 : d;

always @(posedge clk) begin
    q <= gated_d;
end

endmodule