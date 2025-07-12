module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
reg at_max_reg, at_min_reg;
wire at_max = (wave == 5'd31);
wire at_min = (wave == 5'd0);
wire wave_enable = ~((at_max_reg & ~direction) | (at_min_reg & direction));

always @(posedge clk) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
        at_max_reg <= 1'b0;
        at_min_reg <= 1'b1;
    end else begin
        // Pipeline stage 1: Boundary detection
        at_max_reg <= at_max;
        at_min_reg <= at_min;
        
        // Pipeline stage 2: Direction control
        if (at_max_reg & ~direction) begin
            direction <= 1'b1;
        end else if (at_min_reg & direction) begin
            direction <= 1'b0;
        end
        
        // Wave update with explicit enable
        if (wave_enable) begin
            wave <= direction ? wave - 1'b1 : wave + 1'b1;
        end
    end
end

endmodule