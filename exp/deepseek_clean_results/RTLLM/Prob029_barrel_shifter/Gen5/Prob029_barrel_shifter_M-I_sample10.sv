module barrel_shifter #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    input [2:0] ctrl,  // Shift amount (0-7 positions)
    output [WIDTH-1:0] out
);

// Generate all possible rotated versions
wire [WIDTH-1:0] rotated [0:WIDTH-1];
generate
    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin : rotate_gen
        assign rotated[i] = {in[i-:WIDTH], in[WIDTH-1:i]};
    end
endgenerate

// Select the appropriate rotation based on control signal
assign out = rotated[ctrl];

endmodule