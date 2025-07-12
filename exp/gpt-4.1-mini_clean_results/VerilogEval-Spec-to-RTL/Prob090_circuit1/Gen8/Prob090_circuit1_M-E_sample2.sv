module TopModule (
    input  wire a,
    input  wire b,
    output reg  q
);
    always @(*) begin
        q = (a == 1'b1 && b == 1'b1) ? 1'b1 : 1'b0;
    end
endmodule