module TopModule (
    input  a,
    input  b,
    input  c,
    output reg out
);

    always @(*) begin
        case ({a, b, c})
            3'b000: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule