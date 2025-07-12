module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [29:0] concat_vector;
    assign concat_vector = {a, b, c, d, e, f};
    
    assign w = {concat_vector[29:22], 2'b00};
    assign x = {concat_vector[21:14], 2'b00};
    assign y = {concat_vector[13:6], 2'b00};
    assign z = {concat_vector[5:0], 2'b11};

endmodule