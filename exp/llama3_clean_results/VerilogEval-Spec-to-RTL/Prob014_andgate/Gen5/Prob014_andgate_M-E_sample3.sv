module TopModule(
    input  logic a,
    input  logic b,
    output logic out
);

logic [1:0] index;
logic [3:0] lut_out = 4'b0001; // 00:0, 01:0, 10:0, 11:1

always_comb begin
    index = {a, b};
    case(index)
        2'b00: out = lut_out[0];
        2'b01: out = lut_out[1];
        2'b10: out = lut_out[2];
        2'b11: out = lut_out[3];
    endcase
end

endmodule