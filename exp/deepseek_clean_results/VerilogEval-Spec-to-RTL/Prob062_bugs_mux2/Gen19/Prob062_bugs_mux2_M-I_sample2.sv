module TopModule #(
    parameter WIDTH = 8
) (
    input              sel,
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule