module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

typedef enum {INCR, DECR, HOLD} state_t;
reg [1:0] current_state, next_state;
reg [4:0] next_wave;

// State transition logic
always @(*) begin
    case (current_state)
        INCR: begin
            next_wave = wave + 1'b1;
            next_state = (next_wave == 5'd30) ? HOLD : INCR;
        end
        DECR: begin
            next_wave = wave - 1'b1;
            next_state = (next_wave == 5'd1) ? HOLD : DECR;
        end
        HOLD: begin
            next_wave = (current_state == INCR) ? 5'd31 : 5'd0;
            next_state = (current_state == INCR) ? DECR : INCR;
        end
        default: begin
            next_wave = 5'd0;
            next_state = INCR;
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= INCR;
        wave <= 5'd0;
    end else begin
        current_state <= next_state;
        wave <= next_wave;
    end
end

endmodule