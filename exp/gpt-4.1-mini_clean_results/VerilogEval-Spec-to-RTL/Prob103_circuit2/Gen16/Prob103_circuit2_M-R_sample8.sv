module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    case (a + b + c + d)
        0, 2, 4: q = 1'b1; // even number of ones
        default: q = 1'b0; // odd number of ones
    endcase
end

endmodule