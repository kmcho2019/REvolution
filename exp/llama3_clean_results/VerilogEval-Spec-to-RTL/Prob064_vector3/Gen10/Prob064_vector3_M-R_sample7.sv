module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    assign w = {a, b}[7:0];
    assign x = {c, d}[7:0];
    assign y = {e, f}[7:0];
    assign z = {2'b11, {a, b, c, d, e, f}[29:28]};

    // Alternatively, if the above doesn't synthesize as expected due to the direct bit assignment,
    // we could consider the following approach for a cleaner concatenation and splitting:

    // wire [29:0] concatenated_vector;
    // assign concatenated_vector = {a, b, c, d, e, f};
    // wire [31:0] appended_vector = {concatenated_vector, 2'b11};
    // assign w = appended_vector[31:24];
    // assign x = appended_vector[23:16];
    // assign y = appended_vector[15:8];
    // assign z = appended_vector[7:0];

endmodule