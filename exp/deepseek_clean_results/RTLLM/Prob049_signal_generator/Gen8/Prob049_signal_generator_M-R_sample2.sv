module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 0=increment, 1=decrement

// Boundary detection
wire at_max = &wave;    // All bits 1 (31)
wire at_min = ~|wave;   // All bits 0 (0)

// Next wave value calculation
wire [4:0] next_wave = dir ? wave - 1'b1 : wave + 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end else begin
        // Update direction at boundaries
        if (at_max) dir <= 1'b1;
        else if (at_min) dir <= 1'b0;
        
        // Update wave value
        wave <= next_wave;
    end
end

endmodule