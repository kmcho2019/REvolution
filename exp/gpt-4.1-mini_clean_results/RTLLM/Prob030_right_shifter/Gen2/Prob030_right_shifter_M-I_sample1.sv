module right_shifter (
    input wire clk,
    input wire shift_enable,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;
end

always @(posedge clk) begin
    if (shift_enable)
        q <= {d, q[7:1]};
    else
        q <= q;
end

endmodule