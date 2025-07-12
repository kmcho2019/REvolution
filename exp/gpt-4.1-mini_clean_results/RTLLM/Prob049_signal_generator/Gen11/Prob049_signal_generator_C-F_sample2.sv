module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave
    reg [4:0] next_wave;

    // Combinational logic to compute next wave value based on current state and wave
    always @(*) begin
        if (state == 1'b0) begin // increment mode
            if (wave == 5'd31)
                next_wave = wave;   // hold at max before toggling state
            else
                next_wave = wave + 5'd1;
        end else begin // decrement mode
            if (wave == 5'd0)
                next_wave = wave;   // hold at min before toggling state
            else
                next_wave = wave - 5'd1;
        end
    end

    // Sequential logic: update wave and state on clock edge or async reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave <= next_wave;

            // Toggle state when wave hits boundaries
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule