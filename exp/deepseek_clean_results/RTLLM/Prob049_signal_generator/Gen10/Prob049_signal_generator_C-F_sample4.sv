module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing
wire [4:0] next_wave = state ? wave - 1'b1 : wave + 1'b1;
wire at_max = &wave;   // wave == 5'b11111 (31)
wire at_min = ~|wave;  // wave == 5'b00000 (0)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment state
                if (at_max) begin
                    state <= 1'b1;  // Hold max value, change direction next cycle
                end else begin
                    wave <= next_wave;
                end
            end
            1'b1: begin  // Decrement state
                if (at_min) begin
                    state <= 1'b0;  // Hold min value, change direction next cycle
                end else begin
                    wave <= next_wave;
                end
            end
        endcase
    end
end

endmodule