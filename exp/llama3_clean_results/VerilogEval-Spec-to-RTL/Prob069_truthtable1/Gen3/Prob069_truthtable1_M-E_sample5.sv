module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Use a decoder to select between two cases based on 'x3'
wire case1, case2;
assign case1 = ~x3;
assign case2 = x3;

// For case1 (x3 = 0), 'f' is 'x2'
wire f_case1;
assign f_case1 = x2;

// For case2 (x3 = 1), 'f' is 'x1'
wire f_case2;
assign f_case2 = x1;

// Use a multiplexer to select the output 'f' based on 'x3'
assign f = (case1) ? f_case1 : f_case2;

endmodule