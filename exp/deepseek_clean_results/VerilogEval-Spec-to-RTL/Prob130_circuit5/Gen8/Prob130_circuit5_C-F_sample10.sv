module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Concatenate inputs in the order they should be selected (b, e, a, d)
wire [15:0] mux_inputs = {d, a, e, b};

// Select output based on c[1:0] when c is 0-3, otherwise output 'f'
assign q = (|c[3:2]) ? 4'b1111 : mux_inputs[{c[1:0], 2'b00} +: 4];

endmodule