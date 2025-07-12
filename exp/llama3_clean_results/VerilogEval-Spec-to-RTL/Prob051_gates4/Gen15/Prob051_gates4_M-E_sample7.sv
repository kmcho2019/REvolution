// Define the universal logic gate (ULG) module
module UniversalLogicGate(
    input  [3:0] in,  // 4-bit input vector
    input  [1:0] ctrl,  // Control signals to select operation (00: AND, 01: OR, 10: XOR)
    output out         // Output of the selected operation
);

    // Implement the ULG using a LUT or PLA
    always @(*) begin
        case (ctrl)
            2'b00: out = in[3] & in[2] & in[1] & in[0];  // AND operation
            2'b01: out = in[3] | in[2] | in[1] | in[0];  // OR operation
            2'b10: out = in[3] ^ in[2] ^ in[1] ^ in[0];  // XOR operation
            default: out = 1'b0;  // Default output for invalid control
        endcase
    end

endmodule

// Top-level module using the UniversalLogicGate
module TopModule(
    input  [3:0] in,  // 4-bit input vector
    output out_and,   // Output of the AND operation
    output out_or,    // Output of the OR operation
    output out_xor    // Output of the XOR operation
);

    // Instantiate the ULG for each operation
    UniversalLogicGate andGate(in, 2'b00, out_and);
    UniversalLogicGate orGate(in, 2'b01, out_or);
    UniversalLogicGate xorGate(in, 2'b10, out_xor);

endmodule