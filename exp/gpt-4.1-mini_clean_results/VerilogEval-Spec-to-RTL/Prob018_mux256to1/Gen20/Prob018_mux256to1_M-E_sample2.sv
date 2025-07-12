module OneHot256Decoder (
    input  wire [7:0] sel,
    output wire [255:0] one_hot
);
    // Decode 8-bit select into 256 one-hot signals
    // Only one bit in one_hot is '1' corresponding to sel
    assign one_hot = 256'b1 << sel;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [255:0] select_one_hot;
    wire [255:0] anded;

    // Instantiate one-hot decoder for sel
    OneHot256Decoder decoder (
        .sel(sel),
        .one_hot(select_one_hot)
    );

    // AND each input bit with corresponding one_hot select bit
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : AND_BITS
            assign anded[i] = in[i] & select_one_hot[i];
        end
    endgenerate

    // OR all bits of anded signals to get the selected output
    assign out = |anded;
endmodule