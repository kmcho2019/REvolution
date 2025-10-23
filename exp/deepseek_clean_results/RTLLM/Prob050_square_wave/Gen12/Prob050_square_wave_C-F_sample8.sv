module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg [7:0] freq_minus_1;
    
    // Pre-compute (freq - 1) to simplify comparison logic
    always @(*) begin
        freq_minus_1 = freq - 1;
    end

    always @(posedge clk) begin
        if (freq == 0) begin
            // Handle freq=0 case - output stays low
            wave_out <= 1'b0;
            count <= 0;
        end
        else begin
            if (count == freq_minus_1) begin
                // Reset counter and toggle output
                count <= 0;
                wave_out <= ~wave_out;
            end
            else begin
                // Increment counter
                count <= count + 1;
            end
        end
    end

endmodule