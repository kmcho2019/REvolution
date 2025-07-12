module TopModule (
    input  a,
    input  b,
    output reg q
);
    always @(*) begin
        q = a & b;  // AND operation using procedural assignment
    end
endmodule