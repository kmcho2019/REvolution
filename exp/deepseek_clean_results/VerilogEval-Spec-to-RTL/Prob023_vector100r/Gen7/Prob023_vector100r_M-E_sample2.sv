module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

// Base case: single bit
if (WIDTH == 1) begin
    assign out = in;
end
// Recursive case: split and swap halves
else begin
    localparam LEFT_WIDTH = WIDTH / 2;
    localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;
    
    // Instantiate left and right reversers
    TopModule #(LEFT_WIDTH) left_reverser (
        .in(in[WIDTH-1 -: LEFT_WIDTH]),
        .out(out[RIGHT_WIDTH-1:0])
    );
    
    TopModule #(RIGHT_WIDTH) right_reverser (
        .in(in[RIGHT_WIDTH-1:0]),
        .out(out[WIDTH-1 -: RIGHT_WIDTH])
    );
end

endmodule