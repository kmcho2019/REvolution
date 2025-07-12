module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction; // 0 for increment, 1 for decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        // Update wave based on current direction
        wave <= direction ? wave - 1'b1 : wave + 1'b1;
        
        // Toggle direction at boundaries
        if ((wave == 5'd30 && !direction) || (wave == 5'd1 && direction))
            direction <= ~direction;
    end
end

endmodule