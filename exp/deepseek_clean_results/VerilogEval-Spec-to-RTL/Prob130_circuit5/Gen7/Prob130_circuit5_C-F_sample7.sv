module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Efficient 4:1 mux using concatenation and bit selection
// Order matches required outputs: b (00), e (01), a (10), d (11)
wire [15:0] mux_inputs = {d, a, e, b};

// Select output based on c[1:0] when c[3:2] are 0, else output 'f'
assign q = (|c[3:2]) ? 4'b1111 : mux_inputs[c[1:0]*4 +: 4];

endmodule