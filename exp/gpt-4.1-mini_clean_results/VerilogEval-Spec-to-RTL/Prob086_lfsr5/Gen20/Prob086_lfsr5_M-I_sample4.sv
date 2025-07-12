module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2]; // taps at bits 5 and 3 => q[4] and q[2], but only q[2] is XORed with q[0] in Galois scheme

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {q[3:0], 1'b0} ^ (5'b10010 & {5{feedback}}); 
        // shift right by 1: q[4]<=q[3], q[3]<=q[2], ..., q[1]<=q[0], q[0]<=0
        // then XOR feedback on tap positions (bit4 and bit2), which corresponds to 5'b10010
end

endmodule