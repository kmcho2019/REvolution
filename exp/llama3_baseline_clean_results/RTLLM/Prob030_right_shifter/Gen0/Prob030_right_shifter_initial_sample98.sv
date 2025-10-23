module right_shifter(
    input clk,  // Clock signal
    input d,    // 1-bit input signal
    output [7:0] q  // 8-bit output signal
);

reg [7:0] q;  // 8-bit register

initial q = 8'b0;  // Initialize q to 0

always @(posedge clk) begin
    // Right shift the contents of q by 1 bit and insert d into the most significant position
    q <= {d, q[7:1]};  // Alternative way to achieve the same result as (q >> 1) and then assigning q[7] = d
end

endmodule