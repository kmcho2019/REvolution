module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;          // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;
    reg wave_update_en;

    always @(*) begin
        // Default assignments to avoid latches and redundant toggling
        next_state    = state;
        next_wave     = wave;
        wave_update_en = 1'b0;

        if (state == 1'b0) begin // increment state
            if (wave < 5'd31) begin
                next_wave     = wave + 5'd1;
                wave_update_en = 1'b1;
                next_state    = state;
            end else begin
                // wave == 31: saturate and switch direction next cycle
                next_wave     = wave;
                next_state    = 1'b1; // change to decrement
            end
        end else begin // decrement state
            if (wave > 5'd0) begin
                next_wave     = wave - 5'd1;
                wave_update_en = 1'b1;
                next_state    = state;
            end else begin
                // wave == 0: saturate and switch direction next cycle
                next_wave     = wave;
                next_state    = 1'b0; // change to increment
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            // Update wave only if it changes to reduce toggling
            if (wave_update_en)
                wave <= next_wave;
            // Update state always because direction change indicates control
            state <= next_state;
        end
    end

endmodule