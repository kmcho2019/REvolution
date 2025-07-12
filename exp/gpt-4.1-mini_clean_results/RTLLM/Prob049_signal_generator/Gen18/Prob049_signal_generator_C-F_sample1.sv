module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Direction state: 0 = increment, 1 = decrement
    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic: determine next_wave and next_state based on current wave and state
    always @(*) begin
        // Default next values to current
        next_wave  = wave;
        next_state = state;

        if (state == 1'b0) begin
            // Incrementing
            if (wave == 5'd31) begin
                // At upper boundary, toggle direction, hold wave steady this cycle
                next_state = 1'b1;
            end else begin
                // Increment wave
                next_wave = wave + 1'b1;
            end
        end else begin
            // Decrementing
            if (wave == 5'd0) begin
                // At lower boundary, toggle direction, hold wave steady this cycle
                next_state = 1'b0;
            end else begin
                // Decrement wave
                next_wave = wave - 1'b1;
            end
        end
    end

    // Sequential logic: update state and wave with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;       // Start incrementing
            wave  <= 5'd0;       // Initialize wave to 0
        end else begin
            // Update only if value changes to reduce toggling
            if (state != next_state)
                state <= next_state;
            if (wave != next_wave)
                wave <= next_wave;
        end
    end

endmodule