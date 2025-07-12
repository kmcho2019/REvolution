module TopModule(
    input x3,
    input x2,
    input x1,
    output logic f
);

always @(*)
begin
    // Calculate the parity of the number of 1s in x3, x2, and x1
    logic parity;
    parity = x3 ^ x2 ^ x1;
    
    // Adjust for the exception case where x3 and x2 are 1, and x1 is 0
    logic exception_case;
    exception_case = x3 & x2 & ~x1;
    
    // Output f is 1 if the parity is odd and not in the exception case
    f = parity & ~exception_case;
end

endmodule