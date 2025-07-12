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

// One-hot selection vector using continuous assignment
wire [8:0] sel_onehot = 
    (sel == 4'd0) ? 9'b000000001 :
    (sel == 4'd1) ? 9'b000000010 :
    (sel == 4'd2) ? 9'b000000100 :
    (sel == 4'd3) ? 9'b000001000 :
    (sel == 4'd4) ? 9'b000010000 :
    (sel == 4'd5) ? 9'b000100000 :
    (sel == 4'd6) ? 9'b001000000 :
    (sel == 4'd7) ? 9'b010000000 :
    (sel == 4'd8) ? 9'b100000000 :
                    9'b000000000;

// Concatenate all inputs for bitwise selection
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

// Generate output by selecting appropriate input or all 1's
assign out = (|sel_onehot) ? 
             (inputs[0] & {16{sel_onehot[0]}}) |
             (inputs[1] & {16{sel_onehot[1]}}) |
             (inputs[2] & {16{sel_onehot[2]}}) |
             (inputs[3] & {16{sel_onehot[3]}}) |
             (inputs[4] & {16{sel_onehot[4]}}) |
             (inputs[5] & {16{sel_onehot[5]}}) |
             (inputs[6] & {16{sel_onehot[6]}}) |
             (inputs[7] & {16{sel_onehot[7]}}) |
             (inputs[8] & {16{sel_onehot[8]}}) : {16{1'b1}};

endmodule