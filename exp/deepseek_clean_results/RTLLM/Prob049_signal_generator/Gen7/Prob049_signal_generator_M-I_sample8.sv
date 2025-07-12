module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction, next_direction;
wire at_max = &wave;        // All bits 1 (31)
wire at_min = ~|wave;       // All bits 0 (0)
wire change_direction = (direction ? at_min : at_max);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update direction one cycle after detection
        direction <= next_direction;
        
        // Update wave based on current direction
        if (direction) begin
            wave <= wave - 1'b1;
        end else begin
            wave <= wave + 1'b1;
        end
    end
end

// Combinational direction control
always @(*) begin
    if (change_direction) begin
        next_direction = ~direction;
    end else begin
        next_direction = direction;
    end
end

endmodule