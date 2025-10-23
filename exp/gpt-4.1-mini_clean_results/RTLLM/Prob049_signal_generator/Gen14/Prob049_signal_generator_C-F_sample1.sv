module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State: 0 = increment, 1 = decrement
    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic for next_state and next_wave
    always @(*) begin
        next_state = state;
        next_wave  = wave;

        if (state == 1'b0) begin // increment mode
            if (wave == 5'd31) begin
                next_state = 1'b1;   // switch to decrement
                // hold wave at 31 this cycle
            end else begin
                next_wave = wave + 5'd1;
            end
        end else begin // decrement mode
            if (wave == 5'd0) begin
                next_state = 1'b0;   // switch to increment
                // hold wave at 0 this cycle
            end else begin
                next_wave = wave - 5'd1;
            end
        end
    end

    // Sequential logic to update state and wave synchronously with non-blocking assignments
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            // Only update if changed to reduce unnecessary toggling
            if (state != next_state)
                state <= next_state;
            if (wave != next_wave)
                wave <= next_wave;
        end
    end

endmodule