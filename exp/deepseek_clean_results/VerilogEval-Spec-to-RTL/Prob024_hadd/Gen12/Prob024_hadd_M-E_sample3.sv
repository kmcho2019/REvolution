module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Transmission gate based XOR for sum
    wire abar, bbar;
    wire sum1, sum2;
    
    not N1(abar, a);
    not N2(bbar, b);
    
    // Transmission gates forming XOR
    tranif1 TG1(sum1, b, a);
    tranif0 TG2(sum1, bbar, abar);
    
    tranif1 TG3(sum2, a, b);
    tranif0 TG4(sum2, abar, bbar);
    
    // Combine the transmission gate outputs
    or O1(sum, sum1, sum2);
    
    // Standard AND for carry-out (could also use pass transistors)
    and A1(cout, a, b);

endmodule