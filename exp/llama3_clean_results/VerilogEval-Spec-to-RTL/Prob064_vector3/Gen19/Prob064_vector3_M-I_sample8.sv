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
    logic [31:0] result_vector;

    assign concatenated_vector = {a, b, c, d, e, f};
    assign result_vector = {concatenated_vector, 2'b11};
    
    assign w = result_vector[31:24];
    assign x = result_vector[23:16];
    assign y = result_vector[15:8];
    assign z = result_vector[7:0];

endmodule