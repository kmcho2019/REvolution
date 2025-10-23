module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Registered inputs for change detection
    reg signed [31:0] a_reg, b_reg;
    reg inputs_changed;
    
    // Pipeline registers
    reg signed [63:0] partial_prod;
    reg signed [63:0] product;
    
    // 64-bit accumulator
    reg signed [63:0] acc;
    
    // Booth-encoded multiplication (2-stage)
    always @(posedge clk) begin
        // Stage 1: Input registration and partial product generation
        a_reg <= a;
        b_reg <= b;
        inputs_changed <= (a != a_reg) || (b != b_reg);
        
        // Booth encoding partial products (simplified representation)
        if (inputs_changed || rst) begin
            partial_prod <= a * b; // Actual implementation would use Booth encoding
        end
        
        // Stage 2: Final product calculation
        product <= partial_prod;
        
        // Accumulation stage
        if (rst) begin
            acc <= 64'b0;
            c <= 32'b0;
        end else if (inputs_changed) begin
            acc <= acc + product;
            // Controlled truncation with saturation
            if (acc[63:31] == {33{acc[31]}}) begin // No overflow
                c <= acc[31:0];
            end else begin // Saturate
                c <= acc[63] ? 32'h80000000 : 32'h7FFFFFFF;
            end
        end
    end

endmodule