module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Generate all possible 4-bit outputs in parallel
    wire [3:0] all_outputs [255:0];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : output_gen
            assign all_outputs[i] = in[(i*4) +: 4];
        end
    endgenerate

    // One-hot decode the sel input
    wire [255:0] sel_one_hot;
    assign sel_one_hot = (1 << sel);

    // Select the appropriate output using the one-hot signal
    assign out = |(sel_one_hot[255:0] & {
        all_outputs[255], all_outputs[254], /* ... */ all_outputs[0]
    });

endmodule