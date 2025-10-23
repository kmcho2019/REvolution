module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bits_logic
            // out_both[i]: both this bit and neighbor to left (i+1) are 1
            // For i=99, no neighbor to left -> 0
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i + 1];
            end else begin
                assign out_both[i] = 1'b0;
            end

            // out_any[i]: either this bit or neighbor to right (i-1) is 1
            // For i=0, no neighbor to right -> 0
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i - 1];
            end else begin
                assign out_any[i] = 1'b0;
            end

            // out_different[i]: this bit different from neighbor to left with wrap-around
            // neighbor to left for i=0 is in[99]
            wire left_neighbor = (i == 0) ? in[99] : in[i - 1];
            assign out_different[i] = in[i] ^ left_neighbor;
        end
    endgenerate

endmodule