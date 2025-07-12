module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] count;  // 6-bit counter for implicit direction control

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 6'b0;
        wave <= 5'b0;
    end
    else begin
        // Increment counter continuously
        count <= count + 1;
        
        // Generate wave output
        if (count[5] == 0) begin
            // Rising phase (0-31) - output lower 5 bits directly
            wave <= count[4:0];
        end
        else begin
            // Falling phase (32-63) - output inverted lower 5 bits
            wave <= ~count[4:0];
        end
    end
end

endmodule