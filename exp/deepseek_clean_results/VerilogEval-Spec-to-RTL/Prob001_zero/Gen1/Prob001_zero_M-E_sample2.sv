module TopModule (
    output zero
);
    wire dummy_input;  // Unused input
    assign dummy_input = 1'b1;  // Could be anything since it's ANDed with 0
    
    // AND gate where one input is permanently 0
    assign zero = 1'b0 & dummy_input;
endmodule