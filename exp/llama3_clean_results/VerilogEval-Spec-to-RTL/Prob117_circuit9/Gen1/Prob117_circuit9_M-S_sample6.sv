module TopModule(
    input clk,
    input a,
    output reg [2:0] q = 4
);

always @ (posedge clk) begin
    if (~a) begin
        q <= q + 1;
    end
end

endmodule