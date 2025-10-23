module TopModule (
    input  wire a,
    input  wire b,
    output reg  q
);
    // Procedural combinational block implementing AND operation
    always @(*) begin
        q = a & b;
    end
endmodule