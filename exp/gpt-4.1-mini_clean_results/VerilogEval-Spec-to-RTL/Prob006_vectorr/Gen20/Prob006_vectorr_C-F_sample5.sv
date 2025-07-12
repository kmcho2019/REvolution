module BitReverser #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

    // Alternative procedural implementation for clarity or modification (optional)
    // Uncomment the following lines and comment out the generate block above to use this.
    /*
    output reg [WIDTH-1:0] out;
    integer j;
    always @(*) begin
        for (j = 0; j < WIDTH; j = j + 1)
            out[j] = in[WIDTH - 1 - j];
    end
    */
endmodule

module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    BitReverser #(.WIDTH(8)) bit_reverser_inst (
        .in(in),
        .out(out)
    );
endmodule