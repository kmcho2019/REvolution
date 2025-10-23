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

wire [15:0] inputs [0:7];
assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;
assign inputs[3] = d;
assign inputs[4] = e;
assign inputs[5] = f;
assign inputs[6] = g;
assign inputs[7] = h;

wire [2:0] sel_low = sel[2:0];
wire sel_high = sel[3];

// Select output based on sel
// If sel[3]==0 and sel[2:0]<8 => select inputs[sel_low]
// else if sel == 8 => select i
// else output 16'hFFFF
assign out = (~sel_high && (sel_low <= 3'd7)) ? inputs[sel_low] :
             (sel == 4'd8) ? i :
             16'hFFFF;

endmodule