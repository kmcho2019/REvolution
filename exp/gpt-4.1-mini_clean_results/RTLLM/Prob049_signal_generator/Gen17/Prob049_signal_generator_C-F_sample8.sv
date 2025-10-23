module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State: 0 = increment, 1 = decrement
    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic: determine next wave and next state
    always @(*) begin
        // Default to current values
        next_state = state;
        next_wave  = wave;

        if (state == 1'b0) begin // Increment mode
            if (wave == 5'd31) begin
                // At upper bound, hold wave and toggle state next cycle
                next_state = 1'b1;
            end else begin
                next_wave = wave + 1'b1;
            end
        end else begin // Decrement mode
            if (wave == 5'd0) begin
                // At lower bound, hold wave and toggle state next cycle
                next_state = 1'b0;
            end else begin
                next_wave = wave - 1'b1;
            end
        end
    end

    // Sequential logic: update wave and state synchronously with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;    // start incrementing
            wave  <= 5'd0;    // start at zero
        end else begin
            // Update state only if changed to reduce toggling
            if (state != next_state)
                state <= next_state;

            // Update wave only if changed to reduce toggling
            if (wave != next_wave)
                wave <= next_wave;
        end
    end

endmodule