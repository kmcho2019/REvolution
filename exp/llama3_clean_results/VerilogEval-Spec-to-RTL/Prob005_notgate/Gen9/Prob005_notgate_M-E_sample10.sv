module TopModule(
    input  in,
    output out
);
    always @(*)
    begin
        case(in)
            1'b0: out = 1'b1;
            1'b1: out = 1'b0;
            default: out = 1'bx;
        endcase
    end
endmodule