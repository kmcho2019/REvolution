module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Concatenate all possible outputs in order: b, e, a, d
wire [15:0] output_bus = {d, a, e, b};

// Create mask that's all 1s when c >=4
wire invalid_sel = |c[3:2];  // OR of upper 2 bits
wire [3:0] mask = {4{invalid_sel}};

// Select the appropriate 4-bit slice using c[1:0]
wire [3:0] selected = output_bus[{c[1:0], 2'b00} +: 4];

// Final output - selected value OR'd with mask (forces to f when invalid)
assign q = selected | mask;

endmodule