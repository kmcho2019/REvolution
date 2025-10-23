module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    reg signed [31:0] accum_reg;
    wire signed [31:0] next_accum;
    wire signed [31:0] product;
    
    // Parallel multiplication (32x32)
    assign product = a * b;
    
    // Next accumulation value (mux for reset)
    assign next_accum = rst ? 32'd0 : (accum_reg + product);
    
    // Register update
    always @(posedge clk) begin
        accum_reg <= next_accum;
    end
    
    // Output assignment
    assign c = accum_reg;

endmodule