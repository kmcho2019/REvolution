module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;
    assign and_result = a & b;

    assign out_assign = and_result;

    always @(*) begin
        case ({a,b})
            2'b11: out_alwaysblock = 1'b1;
            default: out_alwaysblock = 1'b0;
        endcase
    end

endmodule