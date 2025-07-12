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

    // Stage 1: 2-to-1 muxes controlled by sel[0]
    wire [15:0] mux0_0 = sel[0] ? b : a;  // sel=0 or 1
    wire [15:0] mux0_1 = sel[0] ? d : c;  // sel=2 or 3
    wire [15:0] mux0_2 = sel[0] ? f : e;  // sel=4 or 5
    wire [15:0] mux0_3 = sel[0] ? h : g;  // sel=6 or 7

    // Stage 2: 2-to-1 muxes controlled by sel[1]
    wire [15:0] mux1_0 = sel[1] ? mux0_1 : mux0_0;  // sel=0-3
    wire [15:0] mux1_1 = sel[1] ? mux0_3 : mux0_2;  // sel=4-7

    // Stage 3: 2-to-1 mux controlled by sel[2]
    wire [15:0] mux2_0 = sel[2] ? mux1_1 : mux1_0;  // sel=0-7

    // Stage 4: final selection controlled by sel[3]
    // If sel[3]=0: choose mux2_0 (sel=0-7)
    // If sel=8 (1000): output i
    // If sel>=9: output all ones

    wire sel_eq_8 = (sel == 4'd8);
    wire sel_ge_9 = (sel[3] && (sel != 4'd8)); // sel>=9 excluding 8

    assign out = sel_ge_9 ? 16'hFFFF :
                 (sel_eq_8 ? i : mux2_0);

endmodule