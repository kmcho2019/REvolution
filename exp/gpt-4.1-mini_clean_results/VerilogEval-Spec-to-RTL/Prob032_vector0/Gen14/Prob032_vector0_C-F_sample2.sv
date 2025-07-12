module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output             o0,
    output             o1,
    output             o2
);
    // Internal array to hold outputs for generate loop
    wire [WIDTH-1:0] out_bits;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_assign
            assign out_bits[i] = in_vec[i];
        end
    endgenerate

    // Explicitly assign each output port for clarity and connection
    assign o0 = out_bits[0];
    assign o1 = out_bits[1];
    assign o2 = out_bits[2];

endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Instantiate BitSplitter with parameterized width and generated assignments
    BitSplitter #(.WIDTH(3)) splitter (
        .in_vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2)
    );

    // Directly assign outv to vec for minimal logic and area overhead
    assign outv = vec;

endmodule