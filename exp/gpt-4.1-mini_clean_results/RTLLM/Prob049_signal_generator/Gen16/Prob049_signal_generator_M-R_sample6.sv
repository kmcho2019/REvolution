module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;         // 0: increment, 1: decrement
    reg [4:0] next_wave;
    reg next_state;

    // Combinational logic to compute next wave value and next state
    always @(*) begin
        case (state)
            1'b0: begin // increment
                if (wave == 5'd31) begin
                    next_wave = wave;      // hold max
                    next_state = 1'b1;    // switch to decrement
                end else begin
                    next_wave = wave + 5'd1;
                    next_state = 1'b0;    // remain incrementing
                end
            end
            1'b1: begin // decrement
                if (wave == 5'd0) begin
                    next_wave = wave;      // hold min
                    next_state = 1'b0;    // switch to increment
                end else begin
                    next_wave = wave - 5'd1;
                    next_state = 1'b1;    // remain decrementing
                end
            end
            default: begin
                next_wave = 5'd0;
                next_state = 1'b0;
            end
        endcase
    end

    // Sequential logic: update wave and state on clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start incrementing
        end else begin
            wave  <= next_wave;
            state <= next_state;
        end
    end

endmodule