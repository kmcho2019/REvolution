module TopModule(
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

    // Pack inputs into an array for easy indexing
    wire [15:0] inputs_array [8:0];
    assign inputs_array[0] = a;
    assign inputs_array[1] = b;
    assign inputs_array[2] = c;
    assign inputs_array[3] = d;
    assign inputs_array[4] = e;
    assign inputs_array[5] = f;
    assign inputs_array[6] = g;
    assign inputs_array[7] = h;
    assign inputs_array[8] = i;

    // Output selected input if sel < 9, else all ones
    assign out = (sel < 4'd9) ? inputs_array[sel] : 16'hFFFF;

endmodule