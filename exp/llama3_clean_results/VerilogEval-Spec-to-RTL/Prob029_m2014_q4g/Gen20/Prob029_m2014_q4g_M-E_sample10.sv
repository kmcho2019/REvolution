module TopModule(
    input [2:0] inputs, // inputs[2] = in1, inputs[1] = in2, inputs[0] = in3
    output out
);

// Define the lookup table
wire [0:0] lut_out;
always @(inputs) begin
    case (inputs)
        3'b000: lut_out = 1'b0; // in1 = 0, in2 = 0, in3 = 0
        3'b001: lut_out = 1'b1; // in1 = 0, in2 = 0, in3 = 1
        3'b010: lut_out = 1'b1; // in1 = 0, in2 = 1, in3 = 0
        3'b011: lut_out = 1'b0; // in1 = 0, in2 = 1, in3 = 1
        3'b100: lut_out = 1'b1; // in1 = 1, in2 = 0, in3 = 0
        3'b101: lut_out = 1'b0; // in1 = 1, in2 = 0, in3 = 1
        3'b110: lut_out = 1'b0; // in1 = 1, in2 = 1, in3 = 0
        3'b111: lut_out = 1'b1; // in1 = 1, in2 = 1, in3 = 1
    endcase
end

assign out = lut_out;

endmodule