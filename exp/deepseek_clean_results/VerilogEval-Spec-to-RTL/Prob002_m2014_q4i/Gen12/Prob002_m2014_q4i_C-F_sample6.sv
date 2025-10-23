module TopModule (
    output out
);
    // Define constant value parameter for clarity and potential future use
    localparam CONST_OUT = 1'b0;
    
    // Direct continuous assignment for optimal PPA
    assign out = CONST_OUT;
endmodule