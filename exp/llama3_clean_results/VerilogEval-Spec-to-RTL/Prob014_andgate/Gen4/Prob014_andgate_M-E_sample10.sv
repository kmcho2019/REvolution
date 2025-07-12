module TopModule(
    input  logic a,
    input  logic b,
    output logic out
);

logic [1:0] input_comb;
logic [3:0] lut_out;

// Initialize the LUT with output values for each input combination
initial begin
    lut_out[0] = 1'b0; // 00
    lut_out[1] = 1'b0; // 01
    lut_out[2] = 1'b0; // 10
    lut_out[3] = 1'b1; // 11
end

// Combine inputs into a single index
assign input_comb = {a, b};

// Use the input combination to index into the LUT
assign out = lut_out[input_comb];

endmodule