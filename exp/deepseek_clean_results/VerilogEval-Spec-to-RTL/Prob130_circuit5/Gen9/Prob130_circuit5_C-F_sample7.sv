module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early detection of default case
wire default_case = |c[3:2];

// Concatenate inputs in selection order: [3:0]=b, [7:4]=e, [11:8]=a, [15:12]=d
wire [15:0] mux_inputs = {d, a, e, b};

// Select output based on c[1:0] when in valid range, else output 'f'
assign q = default_case ? 4'b1111 : mux_inputs[c[1:0]*4 +: 4];

endmodule