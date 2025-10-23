module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Internal flip-flops
    reg [7:0] Q;
    
    // Decoded address for output selection
    wire [7:0] sel = (8'b00000001 << {A,B,C});
    
    // Shift register implementation with direct output selection
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift operation
        end
    end
    
    // Output selection using wired-OR
    assign Z = |(Q & sel);
endmodule