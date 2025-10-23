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

assign out = (sel >= 9) ? 16'hFFFF :  // Handle invalid cases first
             (sel == 8) ? i :         // Then check each valid case
             (sel == 7) ? h :
             (sel == 6) ? g :
             (sel == 5) ? f :
             (sel == 4) ? e :
             (sel == 3) ? d :
             (sel == 2) ? c :
             (sel == 1) ? b :
                          a;          // Default to a when sel == 0

endmodule