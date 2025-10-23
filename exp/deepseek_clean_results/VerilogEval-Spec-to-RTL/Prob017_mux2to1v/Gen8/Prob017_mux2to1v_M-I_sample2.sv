module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         en,    // Added enable for power optimization
    output [99:0] out
);

    // Instantiate four 25-bit muxes to reduce fanout
    mux25bit mux0 (.a(a[24:0]),   .b(b[24:0]),   .sel(sel), .en(en), .out(out[24:0]));
    mux25bit mux1 (.a(a[49:25]),  .b(b[49:25]),  .sel(sel), .en(en), .out(out[49:25]));
    mux25bit mux2 (.a(a[74:50]),  .b(b[74:50]),  .sel(sel), .en(en), .out(out[74:50]));
    mux25bit mux3 (.a(a[99:75]),  .b(b[99:75]),  .sel(sel), .en(en), .out(out[99:75]));

endmodule

module mux25bit (
    input  [24:0] a,
    input  [24:0] b,
    input         sel,
    input         en,
    output [24:0] out
);

    // Use clock gating style enable for power optimization
    assign out = en ? (sel ? b : a) : 25'b0;

endmodule