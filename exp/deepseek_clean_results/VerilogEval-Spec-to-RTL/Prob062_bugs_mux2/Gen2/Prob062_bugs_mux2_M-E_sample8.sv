module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Split into upper and lower nibbles
    wire [3:0] a_upper = a[7:4];
    wire [3:0] a_lower = a[3:0];
    wire [3:0] b_upper = b[7:4];
    wire [3:0] b_lower = b[3:0];

    // First level muxes (4-bit each)
    wire [3:0] upper_mux_out = sel ? b_upper : a_upper;
    wire [3:0] lower_mux_out = sel ? b_lower : a_lower;

    // Final output combines both nibbles
    assign out = {upper_mux_out, lower_mux_out};

endmodule