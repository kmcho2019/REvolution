module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal vector bundling the outputs for clarity and grouping
    wire [3:0] outputs_vector;

    // Assign inputs to respective bits of the vector
    // Mapping: outputs_vector[3] = w = a
    //          outputs_vector[2] = x = b
    //          outputs_vector[1] = y = b
    //          outputs_vector[0] = z = c
    assign outputs_vector[3] = a;
    assign outputs_vector[2] = b;
    assign outputs_vector[1] = b;
    assign outputs_vector[0] = c;

    // Unpack vector bits to output ports
    assign w = outputs_vector[3];
    assign x = outputs_vector[2];
    assign y = outputs_vector[1];
    assign z = outputs_vector[0];

endmodule