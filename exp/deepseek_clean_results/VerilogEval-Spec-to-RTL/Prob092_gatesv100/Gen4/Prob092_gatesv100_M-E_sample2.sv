module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: hierarchical pairwise AND structure
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : both_gen
            if (i == 99) begin
                assign out_both[i] = 1'b0;
            end else begin
                assign out_both[i] = in[i] & in[i+1];
            end
        end
    endgenerate

    // out_any: hierarchical pairwise OR structure
    generate
        for (i = 0; i < 100; i = i + 1) begin : any_gen
            if (i == 0) begin
                assign out_any[i] = 1'b0;
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end
        end
    endgenerate

    // out_different: circular shift XOR implementation
    wire [99:0] shifted_in;
    assign shifted_in = {in[0], in[99:1]};  // Circular left shift
    assign out_different = in ^ shifted_in;

endmodule