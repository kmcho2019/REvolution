module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: begin
            out_assign = b;
            out_always = b;
        end
        default: begin
            out_assign = a;
            out_always = a;
        end
    endcase
end

endmodule