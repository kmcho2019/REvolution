module TopModule (
    input  a,
    input  b,
    output reg out
);
    // Use an always block with combinational sensitivity to implement NOR gate procedurally
    always @(*) begin
        out = ~(a | b);
    end
endmodule