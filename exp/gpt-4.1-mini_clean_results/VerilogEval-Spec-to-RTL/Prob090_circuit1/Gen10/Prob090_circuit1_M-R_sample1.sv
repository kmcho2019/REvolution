module TopModule (
    input  wire a,
    input  wire b,
    output reg  q
);
    always @(*) begin
        q = a & b;
    end
endmodule