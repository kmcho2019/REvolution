module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    wire [255:0] select_lines;
    wire [1023:0] selected_bits;

    // One-hot decoder for 8-bit select
    decoder_8to256 decoder (
        .in(sel),
        .out(select_lines)
    );

    // Bitwise AND between input and expanded select lines
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : bit_selection
            assign selected_bits[i*4 +: 4] = in[i*4 +: 4] & {4{select_lines[i]}};
        end
    endgenerate

    // Bitwise OR reduction to get final output
    assign out = |selected_bits;

endmodule

module decoder_8to256 (
    input [7:0] in,
    output reg [255:0] out
);
    always @(*) begin
        out = 256'b0;
        out[in] = 1'b1;
    end
endmodule