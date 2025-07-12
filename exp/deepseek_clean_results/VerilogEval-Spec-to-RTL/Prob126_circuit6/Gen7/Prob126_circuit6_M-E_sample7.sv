module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] intermediate;

// First stage: Create a base pattern using shifts and XOR
assign intermediate = {4{a}} ^ {a, a, a, a} ^ {8{a}};

// Second stage: Apply input-specific transformations
assign q = 
    (a == 3'd0) ? (intermediate ^ 16'h1232) :
    (a == 3'd1) ? (intermediate | 16'hAEE0) :
    (a == 3'd2) ? (intermediate + 16'h27D4) :
    (a == 3'd3) ? (intermediate ^ 16'h5A0E) :
    (a == 3'd4) ? (intermediate - 16'hDF9A) : // 16'h10000 - 16'h2066 = 0xDF9A
    (a == 3'd5) ? (intermediate ^ 16'h64CE) :
    (a == 3'd6) ? (intermediate | 16'hC526) :
                  (intermediate ^ 16'h2F19);  // a == 3'd7

endmodule