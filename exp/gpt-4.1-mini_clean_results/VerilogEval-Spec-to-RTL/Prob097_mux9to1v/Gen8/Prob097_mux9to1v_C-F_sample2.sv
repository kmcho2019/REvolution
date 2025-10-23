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

wire [15:0] inputs [0:8];
assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;
assign inputs[3] = d;
assign inputs[4] = e;
assign inputs[5] = f;
assign inputs[6] = g;
assign inputs[7] = h;
assign inputs[8] = i;

// Detect if sel is within valid range [0..8]
wire sel_valid = (sel <= 4'd8);

// Level 1 mux: select pairs using sel[0]
wire [15:0] mux0 = (sel[0] == 1'b0) ? inputs[0] : inputs[1];
wire [15:0] mux1 = (sel[0] == 1'b0) ? inputs[2] : inputs[3];
wire [15:0] mux2 = (sel[0] == 1'b0) ? inputs[4] : inputs[5];
wire [15:0] mux3 = (sel[0] == 1'b0) ? inputs[6] : inputs[7];
// Single input for 'i' (index 8)
wire [15:0] mux4 = inputs[8];

// Level 2 mux: select between mux0/mux1 and mux2/mux3 with sel[1]
wire [15:0] mux5 = (sel[1] == 1'b0) ? mux0 : mux1;
wire [15:0] mux6 = (sel[1] == 1'b0) ? mux2 : mux3;

// Level 3 mux: select between mux5 and mux6 with sel[2]
wire [15:0] mux7 = (sel[2] == 1'b0) ? mux5 : mux6;

// Level 4 mux: select between mux7 and mux4 with sel[3]
wire [15:0] mux8 = (sel[3] == 1'b0) ? mux7 : mux4;

// Final output mux controlled by sel_valid, avoid unnecessary mux toggling
assign out = sel_valid ? mux8 : 16'hFFFF;

endmodule