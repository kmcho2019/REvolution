module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;          // 0: increment wave, 1: decrement wave
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic for next state and next wave value
    always @(*) begin
        case (state)
            1'b0: begin // Increment mode
                if (wave == 5'd31) begin
                    next_state = 1'b1;   // Switch to decrement mode
                    next_wave  = wave;   // Hold wave this cycle
                end else begin
                    next_state = 1'b0;
                    next_wave  = wave + 5'd1;
                end
            end
            1'b1: begin // Decrement mode
                if (wave == 5'd0) begin
                    next_state = 1'b0;   // Switch to increment mode
                    next_wave  = wave;   // Hold wave this cycle
                end else begin
                    next_state = 1'b1;
                    next_wave  = wave - 5'd1;
                end
            end
            default: begin
                // Defensive default case, reset to initial conditions
                next_state = 1'b0;
                next_wave  = 5'd0;
            end
        endcase
    end

    // Sequential logic: update state and wave on clock edge or reset
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