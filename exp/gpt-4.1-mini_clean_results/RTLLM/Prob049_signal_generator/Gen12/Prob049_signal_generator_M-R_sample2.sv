module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;              // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;

    // Next state and wave computation (combinational)
    always @(*) begin
        next_state = state;
        next_wave  = wave;

        case (state)
            1'b0: begin // Increment mode
                if (wave == 5'd31) begin
                    next_state = 1'b1;       // Switch to decrement mode at peak
                    next_wave  = wave - 5'd1; // Start decrementing immediately
                end else begin
                    next_wave = wave + 5'd1; // Increment wave
                end
            end
            1'b1: begin // Decrement mode
                if (wave == 5'd0) begin
                    next_state = 1'b0;       // Switch to increment mode at trough
                    next_wave  = wave + 5'd1; // Start incrementing immediately
                end else begin
                    next_wave = wave - 5'd1; // Decrement wave
                end
            end
        endcase
    end

    // Sequential update of state and wave on clock or async reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            state <= next_state;
            wave  <= next_wave;
        end
    end

endmodule