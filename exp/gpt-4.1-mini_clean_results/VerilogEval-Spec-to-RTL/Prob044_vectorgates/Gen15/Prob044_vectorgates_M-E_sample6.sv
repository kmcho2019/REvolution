module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    reg [2:0] inv_a;
    reg [2:0] inv_b;

    // Compute bitwise OR combinationally
    assign out_or_bitwise = a | b;

    // Compute logical OR using reduction on concatenated inputs
    assign out_or_logical = |{a, b};

    // Procedural blocks for bitwise NOT of inputs
    always @(*) begin
        inv_a = ~a;
    end

    always @(*) begin
        inv_b = ~b;
    end

    // Concatenate inverted b and a to form out_not
    assign out_not = {inv_b, inv_a};

endmodule