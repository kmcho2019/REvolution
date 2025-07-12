module TopModule(
    input  a,
    input  b,
    output reg out
);
    // Use procedural continuous combinational block instead of assign
    always @(*) begin
        out = ~(a ^ b);  // XNOR operation inside always block
    end
endmodule