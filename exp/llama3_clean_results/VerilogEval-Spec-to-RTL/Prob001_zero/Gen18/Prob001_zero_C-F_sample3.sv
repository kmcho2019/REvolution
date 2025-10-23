module TopModule #(
    parameter OUT_VALUE = 1'b0,
    parameter OUT_WIDTH = 1
) (
    output logic [OUT_WIDTH-1:0] zero
);
    assign zero = {OUT_WIDTH{OUT_VALUE}};
endmodule