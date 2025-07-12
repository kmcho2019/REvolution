module TopModule (
    input  a,    // First input signal
    input  b,    // Second input signal
    output reg out   // NOR gate output (now registered)
);
    // Procedural implementation of NOR gate
    always @(*) begin
        out = ~(a | b);
    end
endmodule