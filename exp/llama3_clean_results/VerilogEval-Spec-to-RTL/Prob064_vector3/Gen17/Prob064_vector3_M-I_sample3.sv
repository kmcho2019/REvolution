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

    logic [31:0] concatenated_and_appended;

    assign concatenated_and_appended = {a, b, c, d, e, f, 2'b11};

    // Simplified bit assignments using ranges
    assign w = concatenated_and_appended[31:24];
    assign x = concatenated_and_appended[23:16];
    assign y = concatenated_and_appended[15:8];
    assign z = concatenated_and_appended[7:0];

endmodule