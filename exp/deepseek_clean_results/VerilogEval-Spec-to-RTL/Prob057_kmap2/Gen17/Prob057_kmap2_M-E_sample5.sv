module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire ab_xor = a ^ b;
wire cd_xnor = ~(c ^ d);
wire ac_xnor = ~(a ^ c);
wire bd_xor = b ^ d;

assign out = (ab_xor & cd_xnor) | 
             (ac_xnor & bd_xor) | 
             (~a & ~b & ~d) | 
             (a & b & c);

endmodule