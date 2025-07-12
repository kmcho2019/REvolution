module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

wire [4:0] next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);
wire toggle_direction = (wave == 5'b11111 && !direction) || 
                       (wave == 5'b00000 && direction);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (toggle_direction) begin
            direction <= ~direction;
            // Hold current value for one cycle before changing direction
        end else begin
            wave <= next_wave;
        end
    end
end

endmodule