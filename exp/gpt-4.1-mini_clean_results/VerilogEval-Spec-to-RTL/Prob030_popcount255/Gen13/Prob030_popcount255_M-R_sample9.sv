module popcount #(parameter WIDTH = 1)(
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Base case: width 1, count is the bit itself
    generate
        if (WIDTH == 1) begin
            assign out = in;
        end else begin
            // Split input into two halves (left and right)
            localparam LEFT_WIDTH = WIDTH/2;
            localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;

            wire [$clog2(LEFT_WIDTH+1)-1:0] left_count;
            wire [$clog2(RIGHT_WIDTH+1)-1:0] right_count;

            popcount #(LEFT_WIDTH) left_pop (
                .in(in[WIDTH-1:WIDTH-LEFT_WIDTH]),
                .out(left_count)
            );

            popcount #(RIGHT_WIDTH) right_pop (
                .in(in[RIGHT_WIDTH-1:0]),
                .out(right_count)
            );

            // Sum counts from left and right halves
            assign out = left_count + right_count;
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Compute full popcount of 255-bit input
    // popcount output width: ceil(log2(256)) = 8 bits, but popcount module outputs 9 bits for WIDTH=255, 
    // so we truncate or assign directly.

    wire [$clog2(255+1)-1:0] popcnt_full; // 8 bits wide

    popcount #(255) pc (
        .in(in),
        .out(popcnt_full)
    );

    // Assign truncated to 8 bits output (max count is 255 fits in 8 bits)
    assign out = popcnt_full;

endmodule