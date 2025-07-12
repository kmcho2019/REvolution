// Module for XOR operation
module XorGate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// Module for D flip-flop
module DFlipFlop(
    input clk,
    input d,
    output reg q
);
    initial q = 0; // Initialize output to a known state
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module
module TopModule(
    input clk,
    input in,
    output out
);
    wire xor_out;
    XorGate xor_inst(
        .a(in),
        .b(out),
        .out(xor_out)
    );
    DFlipFlop dff_inst(
        .clk(clk),
        .d(xor_out),
        .q(out)
    );
endmodule