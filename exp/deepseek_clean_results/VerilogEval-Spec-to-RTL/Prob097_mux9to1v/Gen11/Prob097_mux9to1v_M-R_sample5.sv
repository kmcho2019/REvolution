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

// Continuous assignment implementation
assign out = (sel >= 4'd9) ? 16'hFFFF :  // Invalid cases
             (sel == 4'd0) ? a :         // Case 0
             (sel == 4'd1) ? b :         // Case 1
             (sel == 4'd2) ? c :         // Case 2
             (sel == 4'd3) ? d :         // Case 3
             (sel == 4'd4) ? e :         // Case 4
             (sel == 4'd5) ? f :         // Case 5
             (sel == 4'd6) ? g :         // Case 6
             (sel == 4'd7) ? h :         // Case 7
             (sel == 4'd8) ? i :         // Case 8
             16'hFFFF;                   // Redundant default (never reached)

endmodule