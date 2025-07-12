module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    always @(*) begin
        min = a; // Initialize min with a
        if (b < min) min = b; // Check if b is smaller
        if (c < min) min = c; // Check if c is smaller
        if (d < min) min = d; // Check if d is smaller
    end

endmodule