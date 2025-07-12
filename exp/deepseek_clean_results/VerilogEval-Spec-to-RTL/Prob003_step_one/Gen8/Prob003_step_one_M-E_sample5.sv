module TopModule(output one);
    wire input1, input2;
    
    // Both inputs are tied to 1
    assign input1 = 1;
    assign input2 = 1;
    
    // AND gate that will always output 1
    and AND_GATE(one, input1, input2);
endmodule