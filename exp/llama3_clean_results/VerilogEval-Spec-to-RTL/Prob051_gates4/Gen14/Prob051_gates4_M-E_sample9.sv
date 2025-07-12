// Define the configurable gate module
module ConfigurableGate(
    input [3:0] in,
    input [1:0] control, // 00: AND, 01: OR, 10: XOR
    output out
);

    wire and_out, or_out, xor_out;
    
    // Implement AND operation
    assign and_out = in[3] & in[2] & in[1] & in[0];
    
    // Implement OR operation
    assign or_out = in[3] | in[2] | in[1] | in[0];
    
    // Implement XOR operation
    assign xor_out = (in[3] ^ in[2] ^ in[1] ^ in[0]);
    
    // Use control signal to select the operation
    always @(*) begin
        case (control)
            2'b00: out = and_out;
            2'b01: out = or_out;
            2'b10: out = xor_out;
            default: out = 1'b0;
        endcase
    end

endmodule

// Top-level module instantiating the configurable gate
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Instantiate the configurable gate for AND operation
    ConfigurableGate andGate(in, 2'b00, out_and);
    
    // Instantiate the configurable gate for OR operation
    ConfigurableGate orGate(in, 2'b01, out_or);
    
    // Instantiate the configurable gate for XOR operation
    ConfigurableGate xorGate(in, 2'b10, out_xor);

endmodule