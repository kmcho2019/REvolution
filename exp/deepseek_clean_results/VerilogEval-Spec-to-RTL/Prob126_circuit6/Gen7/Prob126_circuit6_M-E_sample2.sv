module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] pattern1, pattern2, pattern3;

// First pattern generation: based on shifted and inverted bits of 'a'
assign pattern1 = {4{a}} ^ {a, a, a, a, 4'b0000};

// Second pattern: mathematical relationship with 'a'
assign pattern2 = (16'h1234 << a) | (16'h4321 >> a);

// Third pattern: XOR-based transformation
assign pattern3 = {a, ~a, a, ~a} ^ {~a, a, ~a, a};

// Final output selection based on input
assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? (pattern1 ^ pattern3) :
           (a == 3'd2) ? (pattern2[15:0] & 16'h27d4) :
           (a == 3'd3) ? (pattern3 | 16'h5a0e) :
           (a == 3'd4) ? (pattern1 + pattern2 - 16'h2066) :
           (a == 3'd5) ? (pattern2 ^ pattern3 ^ 16'h64ce) :
           (a == 3'd6) ? (pattern1 & pattern3 | 16'hc526) :
                          (pattern2 - pattern1 + 16'h2f19);  // a == 3'd7

endmodule