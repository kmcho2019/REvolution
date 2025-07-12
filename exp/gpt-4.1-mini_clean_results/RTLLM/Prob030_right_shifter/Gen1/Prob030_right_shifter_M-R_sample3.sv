module right_shifter(
    input clk,
    input rst_n,
    input d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule