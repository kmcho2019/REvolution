module TopModule (
    input in,
    output out
);
    // Transmission-gate style implementation
    reg out_reg;
    wire enable = 1'b1;  // Permanently enabled
    
    always @(*) begin
        if (enable) begin
            out_reg = in;  // Simulates pass-transistor behavior
        end
    end
    
    assign out = out_reg;
endmodule