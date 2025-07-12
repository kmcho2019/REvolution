module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

logic [1:0] input_combination;
logic [0:0] lut [3:0];

initial begin
    lut[0] = 1'b0; // a=0, b=0
    lut[1] = 1'b0; // a=0, b=1
    lut[2] = 1'b0; // a=1, b=0
    lut[3] = 1'b1; // a=1, b=1
end

always_comb begin
    input_combination = {a, b};
    case (input_combination)
        2'b00: q = lut[0];
        2'b01: q = lut[1];
        2'b10: q = lut[2];
        2'b11: q = lut[3];
        default: q = 1'b0; // Default value, should not occur
    endcase
end

endmodule