module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // 3-bit LUT implementation of full adder
    // Address bits: {a, b, cin}
    // sum LUT: [0,1,1,0,1,0,0,1]
    // cout LUT: [0,0,0,1,0,1,1,1]
    wire [2:0] address = {a, b, cin};
    
    assign sum = (address == 3'b001) ? 1'b1 :
                (address == 3'b010) ? 1'b1 :
                (address == 3'b100) ? 1'b1 :
                (address == 3'b111) ? 1'b1 : 1'b0;
                
    assign cout = (address == 3'b011) ? 1'b1 :
                 (address == 3'b101) ? 1'b1 :
                 (address == 3'b110) ? 1'b1 :
                 (address == 3'b111) ? 1'b1 : 1'b0;

endmodule