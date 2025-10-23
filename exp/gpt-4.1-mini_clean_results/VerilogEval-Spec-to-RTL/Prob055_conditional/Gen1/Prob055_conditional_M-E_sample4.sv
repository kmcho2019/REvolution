module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        // Start with 'a' as initial minimum
        min = a;
        // Compare and update minimum with 'b'
        if (b < min)
            min = b;
        // Compare and update minimum with 'c'
        if (c < min)
            min = c;
        // Compare and update minimum with 'd'
        if (d < min)
            min = d;
    end

endmodule