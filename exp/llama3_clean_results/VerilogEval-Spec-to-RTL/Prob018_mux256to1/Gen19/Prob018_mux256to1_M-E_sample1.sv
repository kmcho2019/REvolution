module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Generate a binary mask using the select signal
    wire [255:0] mask;
    assign mask = {256{1'b0}};
    always @(*) begin
        mask[sel] = 1'b1;
    end

    // Use the binary mask to select the desired bit from the input vector
    assign out = (in & mask) != 0;

endmodule