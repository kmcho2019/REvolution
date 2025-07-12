module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;           // 0: increment, 1: decrement
    reg [4:0] next_wave;

    // Combinational logic: compute next wave value based on current wave and state
    always @(*) begin
        if (state == 1'b0) begin  // increment mode
            if (wave < 5'd31)
                next_wave = wave + 5'd1;
            else
                next_wave = wave; // saturate at max
        end else begin             // decrement mode
            if (wave > 5'd0)
                next_wave = wave - 5'd1;
            else
                next_wave = wave; // saturate at min
        end
    end

    // Sequential logic: update wave and state synchronously with async reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;       // start incrementing
        end else begin
            wave <= next_wave;

            // Toggle state only at wave boundaries to reverse direction
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule