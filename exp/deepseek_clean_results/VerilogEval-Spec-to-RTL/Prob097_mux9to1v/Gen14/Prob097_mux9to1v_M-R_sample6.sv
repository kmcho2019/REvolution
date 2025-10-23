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

// Implement 4-level binary tree mux using direct assignment chaining
assign out = (sel[3] && |sel[2:0]) ? 16'hFFFF :  // Handle sel=9-15 cases first
             sel[3] ? i :                        // sel=8 case
             sel[2] ? (sel[1] ? (sel[0] ? h : g)  // sel=4-7 cases
                           : (sel[0] ? f : e))   // sel=0-3 cases
                   : (sel[1] ? (sel[0] ? d : c) 
                           : (sel[0] ? b : a));

endmodule