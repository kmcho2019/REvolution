// Parameterized module for AND and OR gates
module GenericGate(
    input [1:0] op, // 2'b00 for AND, 2'b01 for OR
    input a,
    input b,
    input c,
    output y
);
    assign y = (op == 2'b00) ? (a & b & c) : (a | b | c);
endmodule

// TopModule with novel architecture
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    wire and1_out, and2_out, and3_out, and4_out;

    GenericGate and1(2'b00, p1a, p1b, p1c, and1_out);
    GenericGate and2(2'b00, p1d, p1e, p1f, and2_out);
    GenericGate and3(2'b00, p2a, p2b, 1'b0, and3_out); // Using 1'b0 as dummy for 2-input AND
    GenericGate and4(2'b00, p2c, p2d, 1'b0, and4_out); // Using 1'b0 as dummy for 2-input AND

    GenericGate or1(2'b01, and1_out, and2_out, 1'b0, p1y); // Using 1'b0 as dummy for 2-input OR
    GenericGate or2(2'b01, and3_out, and4_out, 1'b0, p2y); // Using 1'b0 as dummy for 2-input OR
endmodule