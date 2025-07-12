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

    logic [29:0] shift_register;
    logic [1:0] append_bits;

    assign append_bits = 2'b11;

    always @(a, b, c, d, e, f) begin
        shift_register = {a, b, c, d, e, f, append_bits};
    end

    assign w = shift_register[31:24];
    assign x = shift_register[23:16];
    assign y = shift_register[15:8];
    assign z = shift_register[7:0];

endmodule