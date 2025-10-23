module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);

always @(*) begin
    out = (sel == 1'b0)? a : b;
end

endmodule