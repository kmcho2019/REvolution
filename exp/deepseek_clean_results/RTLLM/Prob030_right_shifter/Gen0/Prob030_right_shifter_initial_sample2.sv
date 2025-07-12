module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;  // Initialize q to all zeros
end

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift and insert new bit at MSB
end

endmodule