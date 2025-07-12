module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Instantiate the parameterized bit reverser
    BitReverser #(.WIDTH(100)) reverser (
        .in(in),
        .out(out)
    );

endmodule

module BitReverser #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    generate
        if (WIDTH == 1) begin
            assign out = in;
        end
        else if (WIDTH == 2) begin
            assign out = {in[0], in[1]};
        end
        else begin
            // Split into upper and lower halves and recurse
            localparam HALF = WIDTH / 2;
            wire [HALF-1:0] upper_rev, lower_rev;
            
            BitReverser #(.WIDTH(HALF)) upper (
                .in(in[WIDTH-1:HALF]),
                .out(upper_rev)
            );
            
            BitReverser #(.WIDTH(HALF)) lower (
                .in(in[HALF-1:0]),
                .out(lower_rev)
            );
            
            // Concatenate reversed halves (swap positions)
            assign out = {lower_rev, upper_rev};
        end
    endgenerate

endmodule