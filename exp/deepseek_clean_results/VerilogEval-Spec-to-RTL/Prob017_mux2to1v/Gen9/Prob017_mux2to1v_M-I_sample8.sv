module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
    // input         en   // Optional enable for power gating
);

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_group
            // With enable: assign out[(i*10)+9:i*10] = en ? (sel ? b[(i*10)+9:i*10] : a[(i*10)+9:i*10]) : 'b0;
            assign out[(i*10)+9:i*10] = sel ? b[(i*10)+9:i*10] : a[(i*10)+9:i*10];
        end
    endgenerate

endmodule