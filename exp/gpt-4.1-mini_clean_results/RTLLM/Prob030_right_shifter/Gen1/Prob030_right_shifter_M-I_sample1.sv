module right_shifter(
    input clk,
    input rst_n,       // Active low synchronous reset
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!rst_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule