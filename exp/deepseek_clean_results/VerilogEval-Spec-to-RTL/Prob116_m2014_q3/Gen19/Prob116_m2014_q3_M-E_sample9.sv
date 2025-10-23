module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    wire [1:0] sel = {x[3], x[4]};
    wire [3:0] mux_in;
    
    assign mux_in[0] = ~x[1];  // For sel=00
    assign mux_in[1] = x[2];   // For sel=01
    assign mux_in[2] = 1'b1;   // For sel=11
    assign mux_in[3] = x[1];   // For sel=10
    
    assign f = mux_in[sel];
endmodule