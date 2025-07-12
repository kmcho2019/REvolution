module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State definitions
localparam UP = 1'b0;
localparam DOWN = 1'b1;

reg state;  // Current state
reg next_state;  // Next state
reg [4:0] next_wave;  // Next wave value

// Sequential logic for state and wave updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= UP;
        wave <= 5'b0;
    end else begin
        state <= next_state;
        wave <= next_wave;
    end
end

// Combinational logic for next state and wave
always @(*) begin
    case (state)
        UP: begin
            next_wave = wave + 1;
            next_state = (wave == 5'b11110) ? DOWN : UP;
        end
        DOWN: begin
            next_wave = wave - 1;
            next_state = (wave == 5'b00001) ? UP : DOWN;
        end
        default: begin
            next_wave = 5'b0;
            next_state = UP;
        end
    endcase
end

endmodule