// 2:1 Multiplexer using Boolean logic gates
module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    wire a_sel, b_sel;
    
    assign a_sel = a & ~sel;
    assign b_sel = b & sel;
    assign out = a_sel | b_sel;
endmodule