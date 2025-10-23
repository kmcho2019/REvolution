module BitReverser #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    genvar i;
    // Create an array of reversed bits with generate
    wire [WIDTH-1:0] reversed_bits;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : rev_loop
            assign reversed_bits[i] = in[WIDTH - 1 - i];
        end
    endgenerate

    // Assign reversed bits as output in one continuous assignment
    assign out = reversed_bits;
endmodule

module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    BitReverser #(.WIDTH(8)) reverser_inst (
        .in(in),
        .out(out)
    );
endmodule