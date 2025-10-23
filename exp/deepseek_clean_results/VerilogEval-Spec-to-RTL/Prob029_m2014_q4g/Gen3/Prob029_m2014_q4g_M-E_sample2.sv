module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);
    // Concatenate inputs to form selection index
    wire [2:0] sel = {in1, in2, in3};
    
    // LUT implementation of the truth table
    assign out = (sel == 3'b000) ? 1'b1 :
                 (sel == 3'b001) ? 1'b0 :
                 (sel == 3'b010) ? 1'b0 :
                 (sel == 3'b011) ? 1'b1 :
                 (sel == 3'b100) ? 1'b0 :
                 (sel == 3'b101) ? 1'b1 :
                 (sel == 3'b110) ? 1'b1 :
                                   1'b0; // default case (3'b111)
endmodule