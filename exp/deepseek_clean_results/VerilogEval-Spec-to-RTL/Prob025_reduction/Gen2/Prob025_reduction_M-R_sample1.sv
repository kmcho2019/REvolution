module TopModule (
    input [7:0] in,
    output parity
);
    wire p0, p1, p2;
    
    assign p0 = in[0] ^ in[1];
    assign p1 = in[2] ^ in[3];
    assign p2 = in[4] ^ in[5];
    assign p3 = in[6] ^ in[7];
    
    assign p4 = p0 ^ p1;
    assign p5 = p2 ^ p3;
    
    assign parity = p4 ^ p5;
endmodule