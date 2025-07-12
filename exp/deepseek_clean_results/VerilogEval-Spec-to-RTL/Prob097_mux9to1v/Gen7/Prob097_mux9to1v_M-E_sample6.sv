module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

wire default_case = |sel[3:1]; // sel > 8 (since 9-15 have at least one higher bit set)

assign out = (default_case ? 16'hFFFF : 
             (sel == 4'd0) ? a :
             (sel == 4'd1) ? b :
             (sel == 4'd2) ? c :
             (sel == 4'd3) ? d :
             (sel == 4'd4) ? e :
             (sel == 4'd5) ? f :
             (sel == 4'd6) ? g :
             (sel == 4'd7) ? h : i);

endmodule