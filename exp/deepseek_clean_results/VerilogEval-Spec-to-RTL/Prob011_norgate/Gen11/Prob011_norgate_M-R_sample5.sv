module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output reg out   // NOR output (now registered)
);
    // Procedural implementation of NOR gate
    always @(*) begin
        out = ~(a | b);
    end
endmodule