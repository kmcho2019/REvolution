module popcount #(
    parameter WIDTH = 256  // input width (preferably power of two for recursion)
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Base case: WIDTH=1
    generate
        if (WIDTH == 1) begin
            assign out = in[0];
        end else begin
            // Split input into two halves
            localparam HALF = WIDTH/2;
            wire [$clog2(HALF+1)-1:0] pop_left;
            wire [$clog2(HALF+1)-1:0] pop_right;

            popcount #(.WIDTH(HALF)) left_popcount (
                .in(in[HALF-1:0]),
                .out(pop_left)
            );
            popcount #(.WIDTH(HALF)) right_popcount (
                .in(in[WIDTH-1:HALF]),
                .out(pop_right)
            );

            // Sum left and right population counts
            assign out = pop_left + pop_right;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding a zero MSB
    wire [255:0] in_padded = {1'b0, in};

    // Instantiate popcount module for 256-bit input
    wire [8:0] popcnt_9bits; // max 256 ones => 9 bits needed

    popcount #(.WIDTH(256)) pop256 (
        .in(in_padded),
        .out(popcnt_9bits)
    );

    // Output is the lower 8 bits (max count is 255)
    assign out = popcnt_9bits[7:0];

endmodule