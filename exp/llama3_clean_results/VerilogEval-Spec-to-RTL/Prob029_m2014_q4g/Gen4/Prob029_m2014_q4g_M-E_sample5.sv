module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    reg out_reg;
    assign out = out_reg;

    always @(*)
    begin
        case ({in1, in2, in3})
            3'b000: out_reg = 1'b1; // in1 = 0, in2 = 0, in3 = 0
            3'b001: out_reg = 1'b0; // in1 = 0, in2 = 0, in3 = 1
            3'b010: out_reg = 1'b0; // in1 = 0, in2 = 1, in3 = 0
            3'b011: out_reg = 1'b1; // in1 = 0, in2 = 1, in3 = 1
            3'b100: out_reg = 1'b0; // in1 = 1, in2 = 0, in3 = 0
            3'b101: out_reg = 1'b1; // in1 = 1, in2 = 0, in3 = 1
            3'b110: out_reg = 1'b1; // in1 = 1, in2 = 1, in3 = 0
            3'b111: out_reg = 1'b0; // in1 = 1, in2 = 1, in3 = 1
            default: out_reg = 1'b0; // default case
        endcase
    end

endmodule