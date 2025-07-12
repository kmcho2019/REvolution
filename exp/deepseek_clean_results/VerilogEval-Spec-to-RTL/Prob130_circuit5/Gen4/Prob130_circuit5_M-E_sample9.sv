module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Concatenate all inputs in reverse order (d,a,e,b)
wire [15:0] combined_inputs = {d, a, e, b};

// Select output based on c[1:0], or 0xF if c[3] or c[2] is set
assign q = (|c[3:2]) ? 4'b1111 : 
           combined_inputs >> (4 * c[1:0]);

endmodule