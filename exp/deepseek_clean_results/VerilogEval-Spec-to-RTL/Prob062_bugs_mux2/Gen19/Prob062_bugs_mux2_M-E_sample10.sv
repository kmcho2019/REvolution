module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Decode select signal into one-hot
    wire sel_a = ~sel;
    wire sel_b = sel;

    // Gate inputs with decoded select signals
    wire [7:0] gated_a = a & {8{sel_a}};
    wire [7:0] gated_b = b & {8{sel_b}};

    // Combine gated signals
    assign out = gated_a | gated_b;

endmodule