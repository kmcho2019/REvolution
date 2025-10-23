module TopModule (
    output wire out,
    input  wire a,
    input  wire b
);
    // Procedural implementation of AND gate
    always @(*) begin
        out = a & b;
    end
endmodule