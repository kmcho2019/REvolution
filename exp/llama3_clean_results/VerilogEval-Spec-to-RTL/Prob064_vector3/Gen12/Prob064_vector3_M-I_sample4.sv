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

    logic [29:0] concatenated_vector;
    assign concatenated_vector = {a, b, c, d, e, f};
    
    assign w = {concatenated_vector[29], concatenated_vector[28], concatenated_vector[27], concatenated_vector[26], concatenated_vector[25], concatenated_vector[24], concatenated_vector[23], 1'b1};
    assign x = {concatenated_vector[23], concatenated_vector[22], concatenated_vector[21], concatenated_vector[20], concatenated_vector[19], concatenated_vector[18], concatenated_vector[17], concatenated_vector[16]};
    assign y = {concatenated_vector[15], concatenated_vector[14], concatenated_vector[13], concatenated_vector[12], concatenated_vector[11], concatenated_vector[10], concatenated_vector[9], concatenated_vector[8]};
    assign z = {concatenated_vector[7], concatenated_vector[6], concatenated_vector[5], concatenated_vector[4], concatenated_vector[3], concatenated_vector[2], concatenated_vector[1], 1'b1};

endmodule