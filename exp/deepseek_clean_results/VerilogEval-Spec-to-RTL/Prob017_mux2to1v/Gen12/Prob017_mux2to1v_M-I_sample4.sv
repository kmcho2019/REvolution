module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         en,    // New enable signal
    output [99:0] out
);

    // Power-gated mux implementation
    wire [99:0] mux_out;
    assign mux_out = sel ? b : a;
    assign out = en ? mux_out : 100'b0;

    /* Alternative implementation with generate (similar PPA)
    genvar i;
    generate
        for (i=0; i<100; i=i+1) begin : mux_gen
            assign out[i] = en ? (sel ? b[i] : a[i]) : 1'b0;
        end
    endgenerate
    */
endmodule