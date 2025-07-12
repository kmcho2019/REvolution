// Define basic gate modules with one-bit inputs and output

module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module NandGate(input wire a, input wire b, output wire out);
    assign out = ~(a & b);
endmodule

module NorGate(input wire a, input wire b, output wire out);
    assign out = ~(a | b);
endmodule

module XnorGate(input wire a, input wire b, output wire out);
    assign out = ~(a ^ b);
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule


module TopModule(
    input wire a,
    input wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    // Instantiate gates structurally
    AndGate and_inst      (.a(a), .b(b), .out(out_and));
    OrGate or_inst        (.a(a), .b(b), .out(out_or));
    XorGate xor_inst      (.a(a), .b(b), .out(out_xor));
    NandGate nand_inst    (.a(a), .b(b), .out(out_nand));
    NorGate nor_inst      (.a(a), .b(b), .out(out_nor));
    XnorGate xnor_inst    (.a(a), .b(b), .out(out_xnor));
    AndNotGate anotb_inst (.a(a), .b(b), .out(out_anotb));

endmodule