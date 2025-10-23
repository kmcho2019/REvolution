module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    // Sum-of-Products form for out_sop
    // The conditions for logic-1 are: 2 (0010), 7 (0111), 15 (1111)
    // Directly translating these into logical expressions:
    assign out_sop = (!a & b & !c & !d) | 
                     (!a & b & c & d) | 
                     (a & b & c & d);

    // Product-of-Sums form for out_pos
    // To simplify, consider the conditions leading to logic-0 and apply De Morgan's laws
    // However, for efficiency and simplicity in product-of-sums, we'll directly complement the out_sop logic
    assign out_pos = ~(out_sop);
endmodule