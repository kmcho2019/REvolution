module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    wire bc_or;
    wire q_a0;
    wire q_a1;

    assign bc_or = b | c;

    // Generate q for a=0 and a=1 (both same as bc_or)
    assign q_a0 = bc_or;
    assign q_a1 = bc_or;

    // Procedural block for combinational mux on a
    always @(*) begin
        case (a)
            1'b0: q = q_a0;
            1'b1: q = q_a1;
            default: q = 1'b0; // Defensive default
        endcase
    end

endmodule