module BitMux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    wire [99:0] sel_mask, inv_sel_mask;

    // Generate masks from the select signal
    assign sel_mask     = {100{sel}};
    assign inv_sel_mask = {100{~sel}};

    // Bitwise mux: select a or b based on sel using masking
    assign out = (a & inv_sel_mask) | (b & sel_mask);
endmodule