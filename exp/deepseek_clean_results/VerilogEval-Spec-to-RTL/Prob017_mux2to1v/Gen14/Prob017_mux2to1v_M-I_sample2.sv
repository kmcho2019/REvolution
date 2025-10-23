module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Buffer the select signal for better fanout handling
    wire sel_buf;
    BUFX1 sel_buffer (.A(sel), .Y(sel_buf));

    // Implement hierarchical 25-bit mux slices
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux_slice
            assign out[24+25*i:25*i] = sel_buf ? b[24+25*i:25*i] : a[24+25*i:25*i];
        end
    endgenerate

endmodule