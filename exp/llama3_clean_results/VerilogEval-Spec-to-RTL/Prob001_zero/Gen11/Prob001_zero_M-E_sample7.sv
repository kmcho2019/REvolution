module TopModule (
    output zero
);
    // Internal signal to hold the constant value
    reg internal_zero;
    
    // Always block to assign the constant value to internal_zero
    always @(*) begin
        internal_zero = 1'b0;
    end
    
    // Assign the internal signal to the output port
    assign zero = internal_zero;
endmodule