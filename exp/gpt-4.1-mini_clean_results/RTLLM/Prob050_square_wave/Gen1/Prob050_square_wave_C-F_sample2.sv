module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_reg;

    // Register freq to stabilize timing and avoid glitches during freq changes
    always @(posedge clk) begin
        freq_reg <= freq;
    end

    always @(posedge clk) begin
        if (freq_reg == 0) begin
            // Disable counting and toggling when freq is zero
            count <= 0;
            wave_out <= wave_out;
        end else if (count == freq_reg - 1) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule