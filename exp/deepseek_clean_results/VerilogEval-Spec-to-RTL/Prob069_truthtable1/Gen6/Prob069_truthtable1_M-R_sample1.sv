module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement same logic as mux using AND-OR gates
    wire x3_and_x1;
    wire not_x3_and_x2;
    
    assign x3_and_x1 = x3 & x1;
    assign not_x3_and_x2 = ~x3 & x2;
    assign f = x3_and_x1 | not_x3_and_x2;
endmodule