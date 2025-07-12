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

    assign w = {a, b}[9:2];
    assign x = {a, b}[1:0] == 2'b00? {c, d}[9:2] : {c, d}[9:2];
    assign y = {e, f}[9:2];
    assign z = {e, f}[1:0] == 2'b00? {5'b0, 2'b11} : {5'b0, 2'b11};

endmodule