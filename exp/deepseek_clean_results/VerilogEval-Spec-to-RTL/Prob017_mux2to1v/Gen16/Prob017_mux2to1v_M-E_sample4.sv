module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate group enable signals
    wire [9:0] group_en;
    assign group_en = {10{sel}};

    // Generate output using hierarchical muxes
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_group
            assign out[i*10 +: 10] = group_en[i] ? b[i*10 +: 10] : a[i*10 +: 10];
        end
    endgenerate

endmodule