module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    reg [1:0] out_reg;

    always @(*)
    begin
        case (in)
            3'b000: out_reg = 2'b00;
            3'b001, 3'b010, 3'b100: out_reg = 2'b01;
            3'b011, 3'b101, 3'b110: out_reg = 2'b10;
            3'b111: out_reg = 2'b11;
            default: out_reg = 2'b00;
        endcase
    end

    assign out = out_reg;

endmodule