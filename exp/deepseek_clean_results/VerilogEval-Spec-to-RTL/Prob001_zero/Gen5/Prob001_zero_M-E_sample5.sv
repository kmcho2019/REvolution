module TopModule (
    output zero
);
    reg zero_reg = 1'b0;  // Initialize register to 0
    
    // The register maintains its value indefinitely
    always @(*) begin
        zero_reg <= zero_reg;
    end
    
    assign zero = zero_reg;
endmodule