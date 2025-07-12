module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg signed [5:0] signed_wave;  // 5-bit magnitude + sign
reg signed [5:0] increment;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        signed_wave <= 6'sd0;
        increment <= 6'sd1;
        wave <= 5'b0;
    end else begin
        // Update wave value
        signed_wave <= signed_wave + increment;
        
        // Check for boundary crossing (sign change indicates boundary)
        if ((signed_wave[5] ^ (signed_wave + increment)[5]) && 
            (signed_wave + increment) != 6'sd0) begin
            increment <= -increment;
        end
        
        // Output unsigned wave value
        wave <= signed_wave[4:0];
    end
end

endmodule