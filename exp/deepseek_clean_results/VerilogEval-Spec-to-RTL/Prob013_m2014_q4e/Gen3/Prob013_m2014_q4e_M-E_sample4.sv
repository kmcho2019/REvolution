module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Internal signals
    wire nor_result;
    reg  out_reg;
    
    // Combinational NOR logic
    assign nor_result = ~(in1 | in2);
    
    // Sequential element for robustness
    always @(posedge nor_result) begin
        out_reg <= nor_result;
    end
    
    // Optional output buffer (uncomment if needed)
    // bufif1 (out, out_reg, 1'b1);
    
    // Direct output assignment (commented alternative)
    assign out = out_reg;
    
    // Initialization (simulation only)
    initial begin
        out_reg = 1'b0;
    end
endmodule