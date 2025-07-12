module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_nand, ac_nand, bc_nand;
    wire sum_inter1, sum_inter2, sum_inter3;
    
    // Carry-out calculation using NANDs only
    assign ab_nand = ~(a & b);
    assign ac_nand = ~(a & cin);
    assign bc_nand = ~(b & cin);
    assign cout = ~(ab_nand & ac_nand & bc_nand);
    
    // Sum calculation using NANDs only
    assign sum_inter1 = ~(a & b);
    assign sum_inter2 = ~(sum_inter1 & sum_inter1 & cin);
    assign sum_inter3 = ~(sum_inter1 & cin);
    assign sum = ~(sum_inter2 & sum_inter2 & sum_inter3);
endmodule