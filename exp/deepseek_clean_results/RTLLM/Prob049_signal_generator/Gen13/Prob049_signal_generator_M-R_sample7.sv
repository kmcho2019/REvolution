module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Explicit state definitions
localparam STATE_UP = 1'b0;
localparam STATE_DOWN = 1'b1;

reg state;
reg [4:0] next_wave;
reg next_state;

// Combinational logic for next state and wave
always @(*) begin
    case (state)
        STATE_UP: begin
            next_wave = wave + 1'b1;
            next_state = (&wave) ? STATE_DOWN : STATE_UP;
        end
        STATE_DOWN: begin
            next_wave = wave - 1'b1;
            next_state = (wave == 5'b0) ? STATE_UP : STATE_DOWN;
        end
        default: begin
            next_wave = 5'b0;
            next_state = STATE_UP;
        end
    endcase
end

// Sequential logic for state and wave updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= STATE_UP;
    end else begin
        wave <= next_wave;
        state <= next_state;
    end
end

endmodule