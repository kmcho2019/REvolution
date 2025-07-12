module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire at_max = (wave == 5'b11111);
wire at_min = (wave == 5'b00000);
wire next_direction = direction ^ (at_max | at_min);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        direction <= next_direction;
        if (direction) begin
            wave <= wave - 1'b1;
        end
        else begin
            wave <= wave + 1'b1;
        end
    end
end

endmodule