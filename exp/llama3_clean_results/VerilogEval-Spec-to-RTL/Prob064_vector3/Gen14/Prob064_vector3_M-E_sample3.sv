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

    // Concatenation stage
    wire [9:0] ab;
    wire [9:0] cd;
    wire [9:0] ef;

    assign ab = {a, b};
    assign cd = {c, d};
    assign ef = {e, f};

    // Appending stage
    wire [29:0] concatenated_vector;
    wire [31:0] appended_vector;

    assign concatenated_vector = {ab, cd, ef};
    assign appended_vector = {concatenated_vector, 2'b11};

    // Splitting stage
    assign w = appended_vector[31:24];
    assign x = appended_vector[23:16];
    assign y = appended_vector[15:8];
    assign z = appended_vector[7:0];

endmodule