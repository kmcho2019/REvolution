module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire lut_out_00, lut_out_01, lut_out_10, lut_out_11;
    wire sel;

    // LUTs for each region
    assign lut_out_00 = (a == 0 && b == 0) ? (c == 0 && d == 0) ? 0 : (c == 0 && d == 1) ? 1 : (c == 1 && d == 0) ? 1 : 0 : 1'bx;
    assign lut_out_01 = (a == 0 && b == 1) ? (c == 0 && d == 0) ? 1 : (c == 0 && d == 1) ? 0 : (c == 1 && d == 0) ? 0 : 1 : 1'bx;
    assign lut_out_10 = (a == 1 && b == 0) ? (c == 0 && d == 0) ? 1 : (c == 0 && d == 1) ? 0 : (c == 1 && d == 0) ? 1 : 0 : 1'bx;
    assign lut_out_11 = (a == 1 && b == 1) ? (c == 0 && d == 0) ? 0 : (c == 0 && d == 1) ? 1 : (c == 1 && d == 0) ? 1 : 0 : 1'bx;

    // Multiplexer to select the correct output
    assign sel = {a, b};
    always @(sel, lut_out_00, lut_out_01, lut_out_10, lut_out_11) begin
        case (sel)
            2'b00: out = lut_out_00;
            2'b01: out = lut_out_01;
            2'b10: out = lut_out_10;
            2'b11: out = lut_out_11;
            default: out = 1'bx;
        endcase
    end

endmodule