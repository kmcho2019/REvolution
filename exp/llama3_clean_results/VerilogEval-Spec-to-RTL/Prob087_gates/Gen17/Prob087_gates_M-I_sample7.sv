// Define individual gate modules using logical operators
module ANDGate(input logic a, input logic b, output logic out);
    assign out = a && b;
endmodule

module ORGate(input logic a, input logic b, output logic out);
    assign out = a || b;
endmodule

module XORGate(input logic a, input logic b, output logic out);
    assign out = a ^ b;
endmodule

module NANDGate(input logic a, input logic b, output logic out);
    assign out = ~(a && b);
endmodule

module NORGate(input logic a, input logic b, output logic out);
    assign out = ~(a || b);
endmodule

module XNORGate(input logic a, input logic b, output logic out);
    assign out = ~(a ^ b);
endmodule

module ANDNOTGate(input logic a, input logic b, output logic out);
    assign out = a && ~b;
endmodule

// TopModule directly implements the logic for efficiency
module TopModule(
    input  logic a,
    input  logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    // Directly implement the logic within TopModule for efficiency
    // Using always block for stylistic consistency and potential flexibility
    always_comb begin
        out_and = a && b;
        out_or = a || b;
        out_xor = a ^ b;
        out_nand = ~(a && b);
        out_nor = ~(a || b);
        out_xnor = ~(a ^ b);
        out_anotb = a && ~b;
    end

endmodule