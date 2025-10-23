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

always @(*) begin
    case (sel)
        4'd0:  out = a;  // sel=0: select a
        4'd1:  out = b;  // sel=1: select b
        4'd2:  out = c;  // sel=2: select c
        4'd3:  out = d;  // sel=3: select d
        4'd4:  out = e;  // sel=4: select e
        4'd5:  out = f;  // sel=5: select f
        4'd6:  out = g;  // sel=6: select g
        4'd7:  out = h;  // sel=7: select h
        4'd8:  out = i;  // sel=8: select i
        default: out = 16'hFFFF;  // sel=9-15: all 1's
    endcase
end

endmodule