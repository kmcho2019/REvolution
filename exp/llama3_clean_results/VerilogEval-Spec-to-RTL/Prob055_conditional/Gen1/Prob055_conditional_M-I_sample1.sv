module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_reg; // Declare min as a reg

    always @(*) begin
        // Use non-blocking assignments to ensure concurrent execution
        min_reg = (a < b)? (a < c)? (a < d)? a : d : (c < d)? c : d : (b < c)? (b < d)? b : d : (c < d)? c : d;
        min = min_reg; // Assign the result to the output
    end

endmodule