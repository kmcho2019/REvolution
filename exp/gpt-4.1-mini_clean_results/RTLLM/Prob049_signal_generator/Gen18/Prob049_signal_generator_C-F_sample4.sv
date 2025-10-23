module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State encoding: 0 = increment, 1 = decrement
    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic to determine next_wave and next_state
    always @(*) begin
        next_state = state;  // default keep current state
        next_wave  = wave;   // default keep current wave value

        if (state == 1'b0) begin  // increment mode
            if (wave == 5'd31) begin
                next_state = 1'b1;   // toggle to decrement at upper boundary
                // wave stays at 31 this cycle
            end else begin
                next_wave = wave + 1'b1;
            end
        end else begin             // decrement mode
            if (wave == 5'd0) begin
                next_state = 1'b0;   // toggle to increment at lower boundary
                // wave stays at 0 this cycle
            end else begin
                next_wave = wave - 1'b1;
            end
        end
    end

    // Sequential logic: update wave and state on clock edge or async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;     // start incrementing
            wave  <= 5'd0;     // initialize wave to 0
        end else begin
            // Update only if changed to reduce toggling and power
            if (wave != next_wave)
                wave <= next_wave;
            if (state != next_state)
                state <= next_state;
        end
    end

endmodule