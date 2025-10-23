module TopModule(
    input  [3:0] x,
    output      f
);
    // Address bits: {x[2], x[3], x[0], x[1]}
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    
    // LUT bits correspond to f values indexed by addr from 0 to 15:
    // bit15= f(addr=15), bit0 = f(addr=0)
    // From the K-map and above analysis:
    // 16'b1011011100000101
    localparam [15:0] LUT = 16'b1011011100000101;
    
    assign f = LUT[addr];
endmodule