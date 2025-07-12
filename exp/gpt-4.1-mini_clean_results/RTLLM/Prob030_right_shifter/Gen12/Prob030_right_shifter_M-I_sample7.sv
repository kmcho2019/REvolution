module right_shifter (
    input wire clk,
    input wire reset_n,   // Active low asynchronous reset
    input wire d,
    output reg [7:0] q
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule