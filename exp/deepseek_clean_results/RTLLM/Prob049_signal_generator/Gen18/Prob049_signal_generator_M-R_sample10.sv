module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = counting up, 1 = counting down

// Next value calculation
wire [4:0] next_wave = state ? (wave - 1'b1) : (wave + 1'b1);

// State transition conditions
wire at_max = (wave == 5'b11111);
wire at_min = (wave == 5'b00000);
wire change_state = (state ? at_min : at_max);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        if (change_state) begin
            state <= ~state;
            wave <= state ? 5'b11111 : 5'b00000;  // Handle boundary cases
        end else begin
            wave <= next_wave;
        end
    end
end

endmodule