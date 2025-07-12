module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] sel = {x[3], x[2]};
    wire case_00 = 1'b0;
    wire case_01 = x[1] & x[0];
    wire case_11 = ~(x[1] & x[0]);
    wire case_10 = ~x[0] | x[1];
    
    assign f = (sel == 2'b00) ? case_00 :
               (sel == 2'b01) ? case_01 :
               (sel == 2'b11) ? case_11 :
               case_10;
endmodule