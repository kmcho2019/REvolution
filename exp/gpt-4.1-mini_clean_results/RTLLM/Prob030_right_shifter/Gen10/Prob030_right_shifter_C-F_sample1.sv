module right_shifter (
    input wire clk,
    input wire rst_n,  // Active-low asynchronous reset
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule