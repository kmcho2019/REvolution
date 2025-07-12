module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    // Combinational logic block implementing:
    // f = (x3) ? x1 : x2;
    // Using if-else for clarity and ease of modification,
    // ensures synthesis infers a 2:1 mux with minimal logic.
    always @* begin
        if (x3)
            f = x1;
        else
            f = x2;
    end

endmodule