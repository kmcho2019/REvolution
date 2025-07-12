module TopModule #(
    parameter OUT_VALUE = 1'b0,
    parameter OUT_WIDTH = 1
) (
    output logic [OUT_WIDTH-1:0] zero = {OUT_WIDTH{OUT_VALUE}} // Direct assignment within port declaration
);
endmodule