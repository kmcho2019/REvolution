module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement
    reg [4:0] next_wave;

    // Combinational logic: Determine next_wave based on current state and wave.
    // Increment or decrement by 1 unless at boundary, then saturate.
    always @(*) begin
        if (state == 1'b0) begin // incrementing
            if (wave == 5'd31)
                next_wave = wave;  // Saturate at max
            else
                next_wave = wave + 5'd1;
        end else begin           // decrementing
            if (wave == 5'd0)
                next_wave = wave;  // Saturate at min
            else
                next_wave = wave - 5'd1;
        end
    end

    // Sequential logic: Update wave and toggle state on boundaries with async reset.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;  // Start by incrementing
        end else begin
            wave <= next_wave;

            // Toggle direction state exactly when wave reaches boundary
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule