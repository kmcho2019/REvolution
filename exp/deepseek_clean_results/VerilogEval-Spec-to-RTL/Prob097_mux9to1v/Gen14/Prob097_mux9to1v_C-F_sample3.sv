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

// First level: 8-to-1 mux for a-h
wire [15:0] mux_l1;
assign mux_l1 = (sel[2:0] == 3'b000) ? a :
                (sel[2:0] == 3'b001) ? b :
                (sel[2:0] == 3'b010) ? c :
                (sel[2:0] == 3'b011) ? d :
                (sel[2:0] == 3'b100) ? e :
                (sel[2:0] == 3'b101) ? f :
                (sel[2:0] == 3'b110) ? g :
                h; // sel[2:0] == 3'b111

// Second level: 2-to-1 mux between first level and i
wire [15:0] mux_l2 = sel[3] ? i : mux_l1;

// Final output with default case handling
assign out = (sel[3] && |sel[2:0]) ? 16'hFFFF : mux_l2;

endmodule