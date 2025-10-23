// Alternative 1: Using basic logic gates
module TopModule (
    input a,
    input b,
    output out
);
    wire a_and_b, not_a_and_not_b;
    
    assign a_and_b = a & b;
    assign not_a_and_not_b = ~a & ~b;
    assign out = a_and_b | not_a_and_not_b;
endmodule

// Alternative 2: Using always block
/*
module TopModule (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a ^ b);
    end
endmodule
*/