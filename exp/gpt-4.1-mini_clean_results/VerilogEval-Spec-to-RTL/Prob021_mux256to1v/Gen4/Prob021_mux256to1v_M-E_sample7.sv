module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Reshape input into an array of 256 4-bit elements
    wire [3:0] data_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : unpack_in
            assign data_array[i] = in[4*i +: 4];
        end
    endgenerate

    // Generate 256 one-hot signals from sel
    wire [255:0] sel_onehot;
    generate
        for (i = 0; i < 256; i = i + 1) begin : decode_sel
            assign sel_onehot[i] = (sel == i) ? 1'b1 : 1'b0;
        end
    endgenerate

    // Mask each 4-bit element with one-hot and reduce by OR to form output
    wire [3:0] masked [0:255];
    generate
        for (i = 0; i < 256; i = i + 1) begin : mask_and_reduce
            assign masked[i] = data_array[i] & {4{sel_onehot[i]}};
        end
    endgenerate

    // OR-reduce all masked 4-bit signals into out
    // Using a for loop in an always_comb block for reduction
    reg [3:0] out_reg;
    integer j;
    always @(*) begin
        out_reg = 4'b0;
        for (j = 0; j < 256; j = j + 1) begin
            out_reg = out_reg | masked[j];
        end
    end
    assign out = out_reg;

endmodule