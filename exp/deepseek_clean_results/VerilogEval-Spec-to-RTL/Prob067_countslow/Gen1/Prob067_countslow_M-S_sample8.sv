module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= reset ? 4'b0 : (slowena ? (q == 4'd9 ? 4'b0 : q + 1'b1) : q);
end

endmodule