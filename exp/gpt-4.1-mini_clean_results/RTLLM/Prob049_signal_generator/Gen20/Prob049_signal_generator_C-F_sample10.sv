module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave
    reg [4:0] next_wave;

    // Combinational logic: compute next wave value based on current state and wave
    always @(*) begin
        next_wave = (state == 1'b0) ?
                    ((wave == 5'd31) ? wave : wave + 5'd1) :
                    ((wave == 5'd0)  ? wave : wave - 5'd1);
    end

    // Sequential logic: update wave and state on clk posedge or async reset negedge
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start incrementing
        end else begin
            wave <= next_wave;

            // Toggle direction at waveform boundaries
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule