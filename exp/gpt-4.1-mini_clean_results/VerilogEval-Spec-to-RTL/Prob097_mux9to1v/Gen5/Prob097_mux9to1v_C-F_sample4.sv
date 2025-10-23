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

    // Internal wires for hierarchical mux levels
    wire [15:0] level1 [0:4]; // mux pairs at L1 (pairs + singleton)
    wire [15:0] level2 [0:2]; // mux pairs at L2
    wire [15:0] level3;       // mux at L3
    wire [15:0] selected_data;

    // Level 1: pair inputs by sel[0]
    assign level1[0] = (sel[0] == 1'b0) ? inputs_arr[0] : inputs_arr[1]; // a,b
    assign level1[1] = (sel[0] == 1'b0) ? inputs_arr[2] : inputs_arr[3]; // c,d
    assign level1[2] = (sel[0] == 1'b0) ? inputs_arr[4] : inputs_arr[5]; // e,f
    assign level1[3] = (sel[0] == 1'b0) ? inputs_arr[6] : inputs_arr[7]; // g,h
    assign level1[4] = inputs_arr[8];                                     // i (singleton)

    // Level 2: mux pairs by sel[1]
    assign level2[0] = (sel[1] == 1'b0) ? level1[0] : level1[1];
    assign level2[1] = (sel[1] == 1'b0) ? level1[2] : level1[3];
    assign level2[2] = level1[4]; // singleton carried forward

    // Level 3: mux pairs by sel[2]
    assign level3 = (sel[2] == 1'b0) ? level2[0] : level2[1];

    // Final mux: select between level3 and level2[2] (i) by sel[3]
    assign selected_data = (sel[3] == 1'b0) ? level3 : level2[2];

    // Output: if sel in [0..8], output selected_data; else output all ones
    assign out = (sel < 4'd9) ? selected_data : 16'hFFFF;

endmodule