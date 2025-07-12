module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    reg [4:0] result;

    always @(*) begin
        // Perform addition treating inputs as unsigned 4-bit numbers
        // The '+' operator automatically generates a 5-bit result including overflow
        result = x + y;
    end

    assign sum = result;
endmodule