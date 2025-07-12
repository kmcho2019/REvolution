module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

wire at_max = (wave == 5'b11111);
wire at_min = (wave == 5'b00000);
wire change_direction = (direction ? at_min : at_max);
wire update_wave = ~change_direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (change_direction) begin
            direction <= ~direction;
        end
        
        if (update_wave) begin
            wave <= direction ? (wave - 1'b1) : (wave + 1'b1);
        end
    end
end

endmodule