module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update wave based on direction
        if (direction) begin
            wave <= wave - 1'b1;
        end else begin
            wave <= wave + 1'b1;
        end
        
        // Update direction at boundaries
        if ((!direction && (&wave)) begin  // Reached max (31)
            direction <= 1'b1;
        end else if (direction && (wave == 5'b0)) begin  // Reached min (0)
            direction <= 1'b0;
        end
    end
end

endmodule