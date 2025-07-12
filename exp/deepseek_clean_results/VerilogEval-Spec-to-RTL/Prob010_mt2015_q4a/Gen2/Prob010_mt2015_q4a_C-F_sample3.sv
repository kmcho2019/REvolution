module TopModule (
    input x,
    input y,
    output z
);
    (* use_low_power_gates = "true" *)  // Suggestion for synthesis tool to use low-power variants if available
    wire xor_result;
    
    assign xor_result = x ^ y;
    assign z = xor_result & x;
endmodule