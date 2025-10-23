module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output using pass transistor logic
    wire b_bar = ~b;
    assign sum = (a & b_bar) | (~a & b);
    
    // Carry-out using pass transistor AND
    assign cout = a ? b : 1'b0;
endmodule