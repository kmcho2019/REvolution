module right_shifter (
    input wire clk,
    input wire reset_n,  // active low synchronous reset
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!reset_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule