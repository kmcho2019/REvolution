module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 0 = increment, 1 = decrement
wire at_max = &wave;  // All bits 1 (31)
wire at_min = ~|wave; // All bits 0 (0)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end else begin
        // Update direction at boundaries
        if (at_max) dir <= 1'b1;
        else if (at_min) dir <= 1'b0;
        
        // Update wave based on direction
        if (!dir) wave <= wave + !at_max;  // Increment if not at max
        else wave <= wave - !at_min;       // Decrement if not at min
    end
end

endmodule