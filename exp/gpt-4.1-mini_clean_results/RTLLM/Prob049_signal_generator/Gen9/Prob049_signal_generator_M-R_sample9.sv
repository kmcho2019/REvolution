module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;              // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic for next state and wave value
    always @(*) begin
        if (state == 1'b0) begin
            if (wave == 5'd31) begin
                next_state = 1'b1;
                next_wave  = wave - 5'd1;
            end else begin
                next_state = state;
                next_wave  = wave + 5'd1;
            end
        end else begin // state == 1: decrement
            if (wave == 5'd0) begin
                next_state = 1'b0;
                next_wave  = wave + 5'd1;
            end else begin
                next_state = state;
                next_wave  = wave - 5'd1;
            end
        end
    end

    // Sequential logic for state and wave update
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