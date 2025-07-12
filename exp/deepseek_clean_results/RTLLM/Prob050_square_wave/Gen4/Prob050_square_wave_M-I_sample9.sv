module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_1;
    reg counter_zero, counter_zero_reg;
    wire count_enable = ~counter_zero_reg;
    wire wave_toggle = counter_zero_reg;
    
    // Precompute freq-1 when freq changes
    always @(posedge clk) begin
        freq_minus_1 <= freq - 8'd1;
    end

    // Counter update logic with registered comparison
    always @(posedge clk) begin
        counter_zero <= (count == 8'd0);
        counter_zero_reg <= counter_zero;
        
        if (counter_zero) begin
            count <= freq_minus_1;
        end else begin
            count <= count - 8'd1;
        end
    end

    // Clock-gated wave toggle logic
    always @(posedge clk) begin
        if (wave_toggle) begin
            wave_out <= ~wave_out;
        end
    end

endmodule