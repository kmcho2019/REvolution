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

// Select one of three inputs based on 2-bit sel_lower
function [15:0] mux3to1_16;
    input [15:0] in0, in1, in2;
    input [1:0] sel_lower;
    begin
        case (sel_lower)
            2'd0: mux3to1_16 = in0;
            2'd1: mux3to1_16 = in1;
            2'd2: mux3to1_16 = in2;
            default: mux3to1_16 = 16'hFFFF; // Just in case
        endcase
    end
endfunction

wire [15:0] group0 = mux3to1_16(a, b, c, sel[1:0]);
wire [15:0] group1 = mux3to1_16(d, e, f, sel[1:0]);
wire [15:0] group2 = mux3to1_16(g, h, i, sel[1:0]);

assign out = (sel[3:2] == 2'd0) ? group0 :
             (sel[3:2] == 2'd1) ? group1 :
             (sel[3:2] == 2'd2) ? group2 :
                                  16'hFFFF;

endmodule