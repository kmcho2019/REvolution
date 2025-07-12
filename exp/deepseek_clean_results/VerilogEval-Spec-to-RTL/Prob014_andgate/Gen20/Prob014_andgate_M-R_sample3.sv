module TopModule (
    input  wire a,
    input  wire b,
    output reg  out
);
    // Using procedural always block
    always @(*) begin
        out = a & b;
    end
endmodule