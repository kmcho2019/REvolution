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
    assign z = {2'b11, {a, b, c, d, e, f}[29:24]};

endmodule