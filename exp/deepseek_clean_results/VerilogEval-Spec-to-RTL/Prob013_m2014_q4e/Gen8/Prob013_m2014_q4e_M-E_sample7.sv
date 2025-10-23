module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    always @(*) begin
        case ({in1, in2})
            2'b00: out = 1'b1;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b0;
            default: out = 1'b0;
        endcase
    end
endmodule