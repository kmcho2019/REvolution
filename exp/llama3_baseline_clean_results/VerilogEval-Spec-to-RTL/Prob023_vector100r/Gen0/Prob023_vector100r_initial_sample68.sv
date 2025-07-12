module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = {in[0], in[1], in[2], in[3], ... , in[98], in[99]}; // A simple one-liner for this wouldn't work for large bit widths
    // Instead, use a for loop in a generate block to create the reversed output

    // Generate block with for loop
    // But in this case, simple assignment can be used in combination with bit positions for a more direct and less verbose approach

    // Use bit position assignment
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out[99 - i] = in[i];
        end
    endgenerate

endmodule