module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=up, 1=down

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        // Update direction first based on boundary conditions
        direction <= (wave == 5'd31) ? 1'b1 : 
                    (wave == 5'd0) ? 1'b0 : 
                    direction;
        
        // Then update wave based on current direction
        wave <= direction ? wave - 1'b1 : wave + 1'b1;
    end
end

endmodule