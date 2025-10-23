module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;          // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;

    always @(*) begin
        // Default assignments to avoid latches
        next_state = state;
        case (state)
            1'b0: begin // Increment state
                // Saturate at 31, if reached switch direction next cycle
                if (wave == 5'd31) begin
                    next_wave  = wave;      // Saturate at max
                    next_state = 1'b1;      // Change to decrement
                end else begin
                    next_wave  = wave + 5'd1;
                    next_state = state;     // Keep incrementing
                end
            end
            1'b1: begin // Decrement state
                // Saturate at 0, if reached switch direction next cycle
                if (wave == 5'd0) begin
                    next_wave  = wave;      // Saturate at min
                    next_state = 1'b0;      // Change to increment
                end else begin
                    next_wave  = wave - 5'd1;
                    next_state = state;     // Keep decrementing
                end
            end
            default: begin
                // Defensive fallback to safe defaults
                next_wave  = 5'd0;
                next_state = 1'b0;
            end
        endcase
    end

    // Update registers on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave  <= next_wave;
            state <= next_state;
        end
    end

endmodule