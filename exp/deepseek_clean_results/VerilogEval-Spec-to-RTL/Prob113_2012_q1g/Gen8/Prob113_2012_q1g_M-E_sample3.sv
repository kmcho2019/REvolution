module TopModule(
    input [3:0] x,
    output f
);
    wire row00, row01, row11, row10;
    wire x0_n, x1_n;  // Inverted inputs
    
    // Inverters for x[0] and x[1]
    not inv0(x0_n, x[0]);
    not inv1(x1_n, x[1]);
    
    // Row 00: x[3:2]=00
    and and00a(t00a, x1_n, x0_n);
    and and00b(t00b, x1, x0_n);
    or or00(row00, t00a, t00b);
    and and00(row00_final, ~x[3], ~x[2], row00);
    
    // Row 01: x[3:2]=01 (all zeros)
    assign row01_final = 1'b0;
    
    // Row 11: x[3:2]=11
    and and11a(t11a, x1_n, x0_n);
    and and11b(t11b, x1_n, x0);
    and and11c(t11c, x1, x0);
    or or11(row11, t11a, t11b, t11c);
    and and11(row11_final, x[3], x[2], row11);
    
    // Row 10: x[3:2]=10
    and and10a(t10a, x1_n, x0_n);
    and and10b(t10b, x1_n, x0);
    and and10c(t10c, x1, x0_n);
    or or10(row10, t10a, t10b, t10c);
    and and10(row10_final, x[3], ~x[2], row10);
    
    // Final output OR
    or final_or(f, row00_final, row01_final, row11_final, row10_final);
endmodule