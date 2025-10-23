module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    reg [1:0] state;
    reg out_reg;

    always @(*)
    begin
        case ({in1, in2})
            2'b00: state = 2'b00;
            2'b01: state = 2'b01;
            2'b10: state = 2'b01;
            2'b11: state = 2'b00;
        endcase

        case (state)
            2'b00: out_reg = in3;
            2'b01: out_reg = ~in3;
        endcase

        out = out_reg;
    end

endmodule