module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [5:0] dir;  // +1 or -1, 6-bit signed for safe addition

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            dir  <= 6'sd1;   // start by incrementing
        end else begin
            // Calculate next wave value by adding direction
            // Use 6 bits to avoid overflow on addition
            reg signed [5:0] next_wave_ext;
            next_wave_ext = {1'b0, wave} + dir;

            // Check bounds and flip direction if needed
            if (next_wave_ext > 6'd31) begin
                dir <= -dir;                // flip direction
                wave <= 5'd30;              // clamp inside bounds to avoid overflow
            end else if (next_wave_ext < 6'd0) begin
                dir <= -dir;
                wave <= 5'd1;
            end else begin
                wave <= next_wave_ext[4:0];
            end
        end
    end

endmodule