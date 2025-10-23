module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 4'b100;  // Initial value of q

always @(posedge clk) begin
    if (~a) begin
        q <= q + 1'b1;
    end
end

endmodule