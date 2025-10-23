module TopModule (
    output zero
);
    reg out = 1'b1;  // Initialize to 1
    
    // Imaginary clock edge (commented out as not needed for static output)
    // always @(posedge clk) 
    always @(*) begin
        out <= 1'b0;  // Immediately set to 0 and stay there
    end
    
    assign zero = out;
endmodule