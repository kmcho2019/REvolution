module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

assign out = (sel < 9)? 
             ({16{(sel == 0)} && a} | 
              {16{(sel == 1)} && b} | 
              {16{(sel == 2)} && c} | 
              {16{(sel == 3)} && d} | 
              {16{(sel == 4)} && e} | 
              {16{(sel == 5)} && f} | 
              {16{(sel == 6)} && g} | 
              {16{(sel == 7)} && h} | 
              {16{(sel == 8)} && i}) : 
             16'hFFFF;

endmodule