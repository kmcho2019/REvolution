module TopModule #(
    parameter WIDTH = 3
)(
    input  [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] o
);

    wire [WIDTH-1:0] vec_wire;

    // Assign input vector to local wire
    assign vec_wire = vec;

    // Assign local wire to output vector
    assign outv = vec_wire;

    // Use a for-loop to generate individual bit assignments
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign o[i] = vec_wire[i];
        end
    endgenerate

endmodule