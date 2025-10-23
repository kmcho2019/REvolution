module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave
    reg next_state;
    reg [4:0] next_wave;

    // Combinational next state and next wave logic
    always @(*) begin
        next_state = state;
        next_wave  = wave;

        case(state)
            1'b0: begin // increment mode
                if (wave == 5'd31) begin
                    next_state = 1'b1;
                    next_wave  = wave; // hold wave at max for one cycle on state change
                end else begin
                    next_wave = wave + 5'd1;
                end
            end
            1'b1: begin // decrement mode
                if (wave == 5'd0) begin
                    next_state = 1'b0;
                    next_wave  = wave; // hold wave at min for one cycle on state change
                end else begin
                    next_wave = wave - 5'd1;
                end
            end
            default: begin
                next_state = 1'b0;
                next_wave  = 5'd0;
            end
        endcase
    end

    // Sequential register updates with async active-low reset
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