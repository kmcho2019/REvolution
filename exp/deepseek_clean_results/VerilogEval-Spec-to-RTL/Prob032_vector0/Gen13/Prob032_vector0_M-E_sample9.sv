module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Explicit wiring
    wire bit2 = vec[2];
    wire bit1 = vec[1];
    wire bit0 = vec[0];

    // Connect outputs
    assign outv = {bit2, bit1, bit0};
    assign o2 = bit2;
    assign o1 = bit1;
    assign o0 = bit0;

endmodule