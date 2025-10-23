module TopModule (
    input  a,
    input  b,
    output reg out
);
    // Alternative procedural implementation of NOR gate
    // Maintains identical PPA metrics to continuous assignment version
    always @(*) begin
        out = ~(a | b);  // Blocking assignment for combinational logic
    end
endmodule