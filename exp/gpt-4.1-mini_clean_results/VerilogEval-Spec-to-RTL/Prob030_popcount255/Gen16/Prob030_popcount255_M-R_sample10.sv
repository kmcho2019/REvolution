module popcount #(
    parameter WIDTH = 255
)(
    input  [WIDTH-1:0] in,
    output reg [$clog2(WIDTH+1)-1:0] out
);
    // Compute the number of levels needed for the adder tree
    localparam OUT_WIDTH = $clog2(WIDTH+1);
    // Maximum levels needed is ceil(log2(WIDTH))
    localparam LEVELS = $clog2(WIDTH);

    // Intermediate wires for each level, each element holds partial sums
    // The maximum number of elements in any level is ceil(WIDTH / (2^level))
    // Use a 2D array: level -> partial sums
    // Declare a maximum size for the largest level (initial width = WIDTH)
    // We'll store partial sums in a reg array since they're combinational, and assign in an always_comb

    // For combinational logic, use a function to implement the adder tree
    integer i, j;
    reg [OUT_WIDTH-1:0] level_sums [0:WIDTH-1];
    reg [OUT_WIDTH-1:0] next_level_sums [0:WIDTH-1];
    integer current_level_size;

    always @* begin
        // Initialize level 0 with the bits converted to 1-bit counts
        for (i = 0; i < WIDTH; i = i + 1) begin
            level_sums[i] = in[i];
        end
        current_level_size = WIDTH;

        // Iteratively sum pairs until only one sum remains
        while (current_level_size > 1) begin
            for (j = 0; j < current_level_size/2; j = j +1) begin
                next_level_sums[j] = level_sums[2*j] + level_sums[2*j + 1];
            end
            // If odd number of elements, carry last element up
            if (current_level_size % 2 == 1) begin
                next_level_sums[current_level_size/2] = level_sums[current_level_size - 1];
                current_level_size = (current_level_size / 2) + 1;
            end else begin
                current_level_size = current_level_size / 2;
            end
            // Copy next_level_sums to level_sums for next iteration
            for (j = 0; j < current_level_size; j = j + 1) begin
                level_sums[j] = next_level_sums[j];
            end
        end
        out = level_sums[0];
    end
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule