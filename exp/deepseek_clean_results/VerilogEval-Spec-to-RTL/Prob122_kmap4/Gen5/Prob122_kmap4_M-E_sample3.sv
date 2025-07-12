module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Implement using 4:1 mux approach
    wire ab_xor, ab_xnor;
    wire [1:0] sel;
    
    assign ab_xor = a ^ b;
    assign ab_xnor = ~(a ^ b);
    assign sel = {c, d};
    
    // 4:1 mux implementation
    assign out = (sel == 2'b00) ? ab_xor :
                (sel == 2'b01) ? ab_xnor :
                (sel == 2'b10) ? ab_xor :
                (sel == 2'b11) ? ab_xnor :
                1'b0;

endmodule