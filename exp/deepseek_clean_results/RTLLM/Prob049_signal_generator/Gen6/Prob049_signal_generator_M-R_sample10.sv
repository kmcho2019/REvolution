module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State encoding
parameter INCR = 1'b0;
parameter DECR = 1'b1;

reg state;  // Current state
wire next_state;  // Next state
wire [4:0] next_wave;  // Next wave value

// Combinational next-state logic
assign next_state = (~rst_n) ? INCR :  // Reset condition
                    (state == INCR) ? (wave == 5'b11111 ? DECR : INCR) :
                    (wave == 5'b00000 ? INCR : DECR);

// Combinational output logic
assign next_wave = (~rst_n) ? 5'b0 :  // Reset condition
                   (state == INCR) ? (wave + (wave != 5'b11111)) :
                   (wave - (wave != 5'b00000));

// Sequential logic for state and wave updates
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= INCR;
        wave <= 5'b0;
    end else begin
        state <= next_state;
        wave <= next_wave;
    end
end

endmodule