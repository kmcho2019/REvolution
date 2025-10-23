// Define a parametrized gate module
module ParamGate(
    input a,
    input b,
    input [2:0] op,  // operation selector (0: AND, 1: OR, 2: XOR, 3: NAND, 4: NOR, 5: XNOR, 6: AND-NOT)
    output out
);

    wire and_out, or_out, xor_out;
    assign and_out = a && b;
    assign or_out = a || b;
    assign xor_out = a ^ b;

    always @(*) begin
        case (op)
            3'b000: out = and_out;  // AND
            3'b001: out = or_out;    // OR
            3'b010: out = xor_out;  // XOR
            3'b011: out = ~and_out; // NAND
            3'b100: out = ~or_out;  // NOR
            3'b101: out = ~xor_out; // XNOR
            3'b110: out = a && ~b;  // AND-NOT
            default: out = 1'bx;    // invalid operation
        endcase
    end

endmodule

// TopModule instantiates the parametrized gate module
module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    ParamGate and_gate(a, b, 3'b000, out_and);
    ParamGate or_gate(a, b, 3'b001, out_or);
    ParamGate xor_gate(a, b, 3'b010, out_xor);
    ParamGate nand_gate(a, b, 3'b011, out_nand);
    ParamGate nor_gate(a, b, 3'b100, out_nor);
    ParamGate xnor_gate(a, b, 3'b101, out_xnor);
    ParamGate andnot_gate(a, b, 3'b110, out_anotb);

endmodule