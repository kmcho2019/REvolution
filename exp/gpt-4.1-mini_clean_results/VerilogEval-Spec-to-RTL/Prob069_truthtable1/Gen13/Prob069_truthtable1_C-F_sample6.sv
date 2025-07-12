module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    always @(*) begin
        // Minimal Boolean expression implementing the function
        f = (~x3 & x2) | (x3 & x1);
    end

endmodule