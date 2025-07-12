module TopModule (
    input  a,
    input  b,
    output reg out
);
    always @* begin
        out = ~(a ^ b); // XNOR implemented via XOR followed by inversion
    end
endmodule