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

    assign w = {a, b, c, d, e, f}[31:24];
    assign x = {a, b, c, d, e, f}[23:16];
    assign y = {a, b, c, d, e, f}[15:8];
    assign z = {a, b, c, d, e, f}[7:0] | 2'b11;

endmodule