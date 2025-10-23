module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Generate 256 one-hot select lines
    wire [255:0] one_hot_sel;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_one_hot
            assign one_hot_sel[i] = (sel == i);
        end
    endgenerate

    // Slice the input into 256 4-bit chunks
    wire [3:0] in_slices [0:255];
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_slices
            assign in_slices[i] = in[i*4 +: 4];
        end
    endgenerate

    // Mask each 4-bit slice by the corresponding one-hot bit replicated 4 times
    wire [3:0] masked_slices [0:255];
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_masked
            assign masked_slices[i] = in_slices[i] & {4{one_hot_sel[i]}};
        end
    endgenerate

    // OR-reduce all masked slices to get final output
    reg [3:0] out_reg;
    integer j;
    always @(*) begin
        out_reg = 4'b0000;
        for (j = 0; j < 256; j = j + 1) begin
            out_reg = out_reg | masked_slices[j];
        end
    end

    assign out = out_reg;

endmodule