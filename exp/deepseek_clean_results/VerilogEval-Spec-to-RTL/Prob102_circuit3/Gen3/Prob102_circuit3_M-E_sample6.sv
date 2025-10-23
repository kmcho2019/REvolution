module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire [1:0] sel = {a, b};
    wire c_or_d = c | d;
    
    assign q = (sel == 2'b00) ? 1'b0 :
               (sel == 2'b01) ? c_or_d :
               (sel == 2'b10) ? c_or_d :
               c_or_d;
endmodule