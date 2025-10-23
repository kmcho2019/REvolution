module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] sel = {x[3], x[4]};
    wire case_00 = ~x[1];
    wire case_01 = x[1] & x[2];
    wire case_11 = 1'b1;
    wire case_10 = x[1] & ~x[2];
    
    assign f = (sel == 2'b00) ? case_00 :
               (sel == 2'b01) ? case_01 :
               (sel == 2'b11) ? case_11 :
               case_10;
endmodule