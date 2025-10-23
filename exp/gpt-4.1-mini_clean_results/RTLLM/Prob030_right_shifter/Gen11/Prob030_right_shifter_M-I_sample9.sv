module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;
end

wire shift_en;
assign shift_en = (d != q[7]);

always @(posedge clk) begin
    if (shift_en)
        q <= {d, q[7:1]};
    else
        q <= q;
end

endmodule