module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement using pattern matching against cases where f=1
    // Cases: 010 (2), 011 (3), 101 (5), 111 (7)
    assign f = ({x3, x2, x1} == 3'b010) || 
               ({x3, x2, x1} == 3'b011) || 
               ({x3, x2, x1} == 3'b101) || 
               ({x3, x2, x1} == 3'b111);
endmodule