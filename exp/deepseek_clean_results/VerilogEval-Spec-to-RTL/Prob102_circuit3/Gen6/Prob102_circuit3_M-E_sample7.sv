module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Intermediate signals representing input combinations
    wire ab_any = a | b;
    wire cd_any = c | d;
    
    // Mux select lines
    wire [1:0] sel = {ab_any, cd_any};
    
    // Mux implementation
    assign q = (sel == 2'b11) ? 1'b1 :
               (sel == 2'b10) ? 1'b0 :
               (sel == 2'b01) ? 1'b0 :
               (sel == 2'b00) ? 1'b0 : 1'b0;
endmodule