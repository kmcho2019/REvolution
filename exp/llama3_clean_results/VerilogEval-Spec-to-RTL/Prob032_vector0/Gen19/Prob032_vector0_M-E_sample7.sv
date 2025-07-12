module TopModule #(
    parameter WIDTH = 3
)(
    input  [WIDTH-1:0] vec,
    input  mode, // 0: pass-through mode, 1: decode mode
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] o
);

    // Use generate statement to dynamically create the output logic
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // In pass-through mode, directly assign the input vector to the output vector
            // In decode mode, assign individual bits of the input vector to the single-bit outputs
            assign outv[i] = mode ? vec[i] : vec[i];
            assign o[i] = mode ? 1'b0 : vec[i]; // For demonstration, o is always 0 in pass-through mode
        end
    endgenerate

endmodule