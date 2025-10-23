module TopModule (
    input in,
    output out
);
    // Single-entry LUT implementation
    reg lut_out;
    always @(*) begin
        case(in)
            1'b0: lut_out = 1'b0;
            1'b1: lut_out = 1'b1;
        endcase
    end
    assign out = lut_out;
endmodule