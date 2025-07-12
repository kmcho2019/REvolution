module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [5:0] wave_ext; // holds values -1 to 32 internally to detect boundaries easily
    reg              dir;      // 0 = increment, 1 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave_ext <= 6'sd0;
            dir      <= 1'b0;
            wave     <= 5'd0;
        end else begin
            // Update wave_ext based on direction
            if (dir == 1'b0) begin
                wave_ext <= wave_ext + 6'sd1;
                // Check if upper boundary reached
                if (wave_ext + 6'sd1 >= 6'sd31)
                    dir <= 1'b1; // switch to decrement
            end else begin
                wave_ext <= wave_ext - 6'sd1;
                // Check if lower boundary reached
                if (wave_ext - 6'sd1 <= 6'sd0)
                    dir <= 1'b0; // switch to increment
            end

            // Assign output wave as lower 5 bits of wave_ext
            // Since wave_ext is always between 0 and 31 inclusive
            wave <= wave_ext[4:0];
        end
    end

endmodule