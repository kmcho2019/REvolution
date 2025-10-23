module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] intermediate;

// First stage: create a base pattern
assign intermediate = {4{a}} ^ {a, a, a, a} ^ {a[0], a[1], a[2], 3'b0, a, 3'b0, a[2:0]};

// Second stage: apply transformations based on input
assign q = (intermediate << a) | 
           ({intermediate[7:0], intermediate[15:8]} >> a) ^ 
           (16'h1234 + {12'b0, a});

endmodule