module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

// Direct assignment is already quite efficient; consider synthesis options for further optimization
assign out = in[sel];

endmodule