module TopModule (
    input  a,
    input  b,
    output reg q
);
    always @(a or b) begin
        q = a & b;
    end
endmodule