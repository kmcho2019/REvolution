module TopModule(
    input a,
    input b,
    input sel,
    output out
);

always @(*) begin
    case (sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 1'bx; // default value, should not occur
    endcase
end

endmodule