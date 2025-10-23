// 2-input OR gate module for modular and reusable design
module OrGate2 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] x,
    input  wire [WIDTH-1:0] y,
    output wire [WIDTH-1:0] z
);
    assign z = x | y;
endmodule

module TopModule(
    input  wire a,  // unused in output
    input  wire b,
    input  wire c,
    input  wire d,  // unused in output
    output wire q
);
    // Output q = b OR c (inputs a and d do not affect output)
    wire [0:0] b_vec = b;
    wire [0:0] c_vec = c;
    wire [0:0] q_vec;

    OrGate2 #(1) or_gate_inst(
        .x(b_vec),
        .y(c_vec),
        .z(q_vec)
    );

    assign q = q_vec[0];
endmodule