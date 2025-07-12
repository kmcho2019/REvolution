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
    output reg [15:0] out
);

// 3-to-1 mux function for 16-bit inputs
function [15:0] mux3to1;
    input [15:0] x0, x1, x2;
    input [1:0]  sel2;
    begin
        case(sel2)
            2'd0: mux3to1 = x0;
            2'd1: mux3to1 = x1;
            2'd2: mux3to1 = x2;
            default: mux3to1 = 16'hFFFF; // Just in case
        endcase
    end
endfunction

reg [15:0] group0, group1, group2;

always @(*) begin
    // Lower 2 bits select inside groups
    group0 = mux3to1(a,b,c, sel[1:0]);
    group1 = mux3to1(d,e,f, sel[1:0]);
    group2 = mux3to1(g,h,i, sel[1:0]);

    // Upper 2 bits select the group or default to 16'hFFFF
    case(sel[3:2])
        2'd0: out = group0;        // sel = 0..3
        2'd1: out = group1;        // sel = 4..7
        2'd2: out = group2;        // sel = 8..11 (only 8 valid here)
        default: out = 16'hFFFF;   // sel = 12..15
    endcase

    // Also mask out invalid sel values from 9 to 11 to all ones
    if (sel > 4'd8)
        out = 16'hFFFF;
end

endmodule