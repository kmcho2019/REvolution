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

    // Pack inputs into array for indexed access
    wire [15:0] inputs_arr [0:8];
    assign inputs_arr[0] = a;
    assign inputs_arr[1] = b;
    assign inputs_arr[2] = c;
    assign inputs_arr[3] = d;
    assign inputs_arr[4] = e;
    assign inputs_arr[5] = f;
    assign inputs_arr[6] = g;
    assign inputs_arr[7] = h;
    assign inputs_arr[8] = i;

    // Stage 1: mux pairs of inputs (indices 0..8), last input paired with constant
    wire [15:0] stage1 [0:4];
    assign stage1[0] = (sel[0] == 1'b0) ? inputs_arr[0] : inputs_arr[1];
    assign stage1[1] = (sel[0] == 1'b0) ? inputs_arr[2] : inputs_arr[3];
    assign stage1[2] = (sel[0] == 1'b0) ? inputs_arr[4] : inputs_arr[5];
    assign stage1[3] = (sel[0] == 1'b0) ? inputs_arr[6] : inputs_arr[7];
    // For inputs_arr[8], pair with 16'hFFFF as default for sel>8
    assign stage1[4] = (sel[0] == 1'b0) ? inputs_arr[8] : 16'hFFFF;

    // Stage 2: mux pairs of stage1 outputs
    wire [15:0] stage2 [0:2];
    assign stage2[0] = (sel[1] == 1'b0) ? stage1[0] : stage1[1];
    assign stage2[1] = (sel[1] == 1'b0) ? stage1[2] : stage1[3];
    // Last element paired with 16'hFFFF for unused inputs
    assign stage2[2] = stage1[4]; // No pair needed here

    // Stage 3: mux stage2 outputs
    wire [15:0] stage3 [0:1];
    assign stage3[0] = (sel[2] == 1'b0) ? stage2[0] : stage2[1];
    assign stage3[1] = stage2[2]; // paired with 16'hFFFF later

    // Stage 4: final mux
    wire [15:0] mux_out = (sel[3] == 1'b0) ? stage3[0] : stage3[1];

    // Output: if sel<9 output mux_out else 16'hFFFF
    assign out = (sel < 4'd9) ? mux_out : 16'hFFFF;

endmodule