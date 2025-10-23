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

    // First level muxes: 5 outputs (pairs + singleton)
    wire [15:0] level1 [0:4];
    genvar idx;
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : gen_level1
            assign level1[idx] = (sel[0] == 1'b0) ? inputs_arr[2*idx] : inputs_arr[2*idx + 1];
        end
    endgenerate
    // Singleton input for last element (index 8)
    assign level1[4] = inputs_arr[8];

    // Second level muxes: 3 outputs (pair + singleton)
    wire [15:0] level2 [0:2];
    generate
        for (idx = 0; idx < 2; idx = idx + 1) begin : gen_level2
            assign level2[idx] = (sel[1] == 1'b0) ? level1[2*idx] : level1[2*idx + 1];
        end
    endgenerate
    // Singleton carried forward
    assign level2[2] = level1[4];

    // Third level muxes: 2 outputs (pair)
    wire [15:0] level3 [0:1];
    assign level3[0] = (sel[2] == 1'b0) ? level2[0] : level2[1];
    assign level3[1] = level2[2];

    // Final mux: select between the two level3 outputs
    wire [15:0] selected_data;
    assign selected_data = (sel[3] == 1'b0) ? level3[0] : level3[1];

    // Output with all ones for sel >= 9
    assign out = (sel < 4'd9) ? selected_data : 16'hFFFF;

endmodule