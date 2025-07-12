module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_logic
            // out_both[i]: both this bit and left neighbor are 1
            // For i=99, no left neighbor, assign 0
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i+1];
            end else begin
                assign out_both[i] = 1'b0;
            end

            // out_any[i]: any of this bit or right neighbor are 1
            // For i=0, no right neighbor, assign 0
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i-1];
            end else begin
                assign out_any[i] = 1'b0;
            end

            // out_different[i]: bit differs from left neighbor, with wrap-around
            // left neighbor index = (i + 1) mod 100
            wire left_neighbor = (i < 99) ? in[i+1] : in[0];
            assign out_different[i] = in[i] ^ left_neighbor;
        end
    endgenerate

endmodule