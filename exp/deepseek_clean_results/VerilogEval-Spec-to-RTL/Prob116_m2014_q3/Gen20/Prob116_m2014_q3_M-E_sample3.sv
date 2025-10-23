module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] sel = {x[3], x[4]};
    wire [3:0] mux_in;
    
    // Row 00: All don't-cares set to 0
    assign mux_in[0] = 1'b0;
    
    // Row 01: Simplified logic (x[2]&~x[1] | x[2]&x[1] = x[2])
    assign mux_in[1] = x[2];
    
    // Row 11: Simplified to 1 for first two columns
    assign mux_in[2] = ~x[1] | ~x[2];
    
    // Row 10: Simplified logic
    assign mux_in[3] = ~x[2];
    
    assign f = mux_in[sel];
endmodule