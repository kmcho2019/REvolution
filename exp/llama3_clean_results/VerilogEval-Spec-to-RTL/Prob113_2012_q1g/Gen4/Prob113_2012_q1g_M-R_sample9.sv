module TopModule(
    input  [3:0] x,
    output       f
);

    // Define intermediate variables for each relevant condition
    wire cond_00_00, cond_00_10, cond_11_00, cond_11_01, cond_11_11, cond_10_00, cond_10_01, cond_10_10;
    
    assign cond_00_00 = (x[2] == 1'b0 && x[3] == 1'b0 && x[0] == 1'b0 && x[1] == 1'b0);
    assign cond_00_10 = (x[2] == 1'b0 && x[3] == 1'b0 && x[0] == 1'b1 && x[1] == 1'b0);
    assign cond_11_00 = (x[2] == 1'b1 && x[3] == 1'b1 && x[0] == 1'b0 && x[1] == 1'b0);
    assign cond_11_01 = (x[2] == 1'b1 && x[3] == 1'b1 && x[0] == 1'b0 && x[1] == 1'b1);
    assign cond_11_11 = (x[2] == 1'b1 && x[3] == 1'b1 && x[0] == 1'b1 && x[1] == 1'b1);
    assign cond_10_00 = (x[2] == 1'b1 && x[3] == 1'b0 && x[0] == 1'b0 && x[1] == 1'b0);
    assign cond_10_01 = (x[2] == 1'b1 && x[3] == 1'b0 && x[0] == 1'b0 && x[1] == 1'b1);
    assign cond_10_10 = (x[2] == 1'b1 && x[3] == 1'b0 && x[0] == 1'b1 && x[1] == 1'b0);
    
    // Use the intermediate variables to determine f
    assign f = cond_00_00 || cond_00_10 || cond_11_00 || cond_11_01 || cond_11_11 || cond_10_00 || cond_10_01 || cond_10_10;

endmodule