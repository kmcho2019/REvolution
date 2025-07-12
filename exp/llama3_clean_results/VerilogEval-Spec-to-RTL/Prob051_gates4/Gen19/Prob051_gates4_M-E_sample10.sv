// Define the universal gate module
module UniversalGate(
    input  [1:0] control,  // 00: AND, 01: OR, 10: XOR
    input  [3:0] data_in,
    output out
);

    wire and_out, or_out, xor_out;
    
    // Implement AND operation
    assign and_out = data_in[3] & data_in[2] & data_in[1] & data_in[0];
    
    // Implement OR operation
    assign or_out = data_in[3] | data_in[2] | data_in[1] | data_in[0];
    
    // Implement XOR operation
    assign xor_out = data_in[3] ^ data_in[2] ^ data_in[1] ^ data_in[0];
    
    // Use a multiplexer to select the output based on the control input
    always @(*) begin
        case(control)
            2'b00: out = and_out;
            2'b01: out = or_out;
            2'b10: out = xor_out;
            default: out = 1'b0;  // Default or reset state
        endcase
    end

endmodule

// Top-level module using the universal gate
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    
    // Instantiate universal gates for AND, OR, and XOR operations
    UniversalGate andGate(2'b00, in, out_and);
    UniversalGate orGate(2'b01, in, out_or);
    UniversalGate xorGate(2'b10, in, out_xor);

endmodule