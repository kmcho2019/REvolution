// Define a module for the XOR gate
module XORGate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// Define a module for the D flip-flop
module DFF(
    input clk,
    input d,
    output reg q = 1'b0
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule using the D flip-flop and XOR gate modules
module TopModule(
    input clk,
    input in,
    output out
);
    wire xor_out;

    // Instantiate the XOR gate
    XORGate xor_gate(
        .a(in),
        .b(out),
        .out(xor_out)
    );

    // Instantiate the D flip-flop
    DFF dff(
        .clk(clk),
        .d(xor_out),
        .q(out)
    );
endmodule