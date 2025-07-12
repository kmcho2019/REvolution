module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = up (increment), 1 = down (decrement)

// Boundary detection
wire at_max = (wave == 5'd31);
wire at_min = (wave == 5'd0);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update direction at boundaries
        if (at_max) direction <= 1'b1;
        else if (at_min) direction <= 1'b0;
        
        // Update wave value
        case (direction)
            1'b0: wave <= wave + 1'b1;  // Increment
            1'b1: wave <= wave - 1'b1;  // Decrement
        endcase
    end
end

endmodule