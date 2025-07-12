module right_shifter (
    input clk, 
    input d, 
    output reg [7:0] q
);

initial 
    q = 8'b0;

always @(posedge clk) begin
    // Right shift the 'q' register by 1 bit
    q <= (q >> 1);
    // Insert the new input bit 'd' into the most significant position of the register
    q[7] = d;
end

endmodule