module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

typedef enum {UP, DOWN} state_t;
state_t state, next_state;

wire [4:0] next_up = wave + 1'b1;
wire [4:0] next_down = wave - 1'b1;
wire will_hit_max = (next_up == 5'b11111);
wire will_hit_min = (next_down == 5'b00000);

always @(*) begin
    case (state)
        UP: next_state = will_hit_max ? DOWN : UP;
        DOWN: next_state = will_hit_min ? UP : DOWN;
        default: next_state = UP;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= UP;
    end else begin
        state <= next_state;
        case (state)
            UP: wave <= next_up;
            DOWN: wave <= next_down;
        endcase
    end
end

endmodule