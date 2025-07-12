module TopModule (
    input clk,
    input a,
    output reg q
);

wire a_inv;
assign a_inv = ~a;

always @(posedge clk) begin
    q <= a_inv;
end

endmodule