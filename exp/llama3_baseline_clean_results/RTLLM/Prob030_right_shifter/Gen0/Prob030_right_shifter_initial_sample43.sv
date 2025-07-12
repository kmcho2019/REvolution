module right_shifter(
    input clk,  // Clock signal
    input d,    // 1-bit input to be right-shifted
    output reg [7:0] q  // 8-bit output representing the result of the right shift operation
);

initial q = 8'd0;  // Initialize q to 0

always @(posedge clk) begin
    q[7] = d;  // Assign the most significant bit of q the value of d
    q[6:0] = q[7:1];  // Right shift q by 1 bit, except for the most significant bit which is set above
end

endmodule