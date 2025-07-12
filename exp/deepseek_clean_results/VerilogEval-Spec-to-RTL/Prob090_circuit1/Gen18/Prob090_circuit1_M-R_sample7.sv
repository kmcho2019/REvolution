module TopModule (
    input  a,
    input  b,
    output reg q
);
    always @* begin
        q = a & b;  // AND gate implementation using always block
    end
endmodule