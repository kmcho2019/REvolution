module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg  q
);

    always @(*) begin
        q = (a | b) & (c | d);
    end

endmodule