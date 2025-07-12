// Define the TopModule with a single, configurable 4-input LUT
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Define the control signal
    reg [1:0] control;

    // Define the LUT
    reg [3:0] lut_out;

    // Define the output multiplexer
    reg out_and_reg, out_or_reg, out_xor_reg;

    // Program the LUT with the truth tables of the AND, OR, and XOR operations
    always @(*) begin
        case (control)
            2'b00: lut_out = (in[3] & in[2] & in[1] & in[0]); // AND
            2'b01: lut_out = (in[3] | in[2] | in[1] | in[0]); // OR
            2'b10: lut_out = (in[3] ^ in[2] ^ in[1] ^ in[0]); // XOR
            default: lut_out = 4'b0;
        endcase
    end

    // Decode the control signal
    always @(*) begin
        case (control)
            2'b00: begin out_and_reg = lut_out; out_or_reg = 1'b0; out_xor_reg = 1'b0; end
            2'b01: begin out_and_reg = 1'b0; out_or_reg = lut_out; out_xor_reg = 1'b0; end
            2'b10: begin out_and_reg = 1'b0; out_or_reg = 1'b0; out_xor_reg = lut_out; end
            default: begin out_and_reg = 1'b0; out_or_reg = 1'b0; out_xor_reg = 1'b0; end
        endcase
    end

    // Assign the output of the LUT to the corresponding output port
    assign out_and = out_and_reg;
    assign out_or = out_or_reg;
    assign out_xor = out_xor_reg;

    // Set the control signal
    assign control = 2'b00; // AND
    // assign control = 2'b01; // OR
    // assign control = 2'b10; // XOR
endmodule