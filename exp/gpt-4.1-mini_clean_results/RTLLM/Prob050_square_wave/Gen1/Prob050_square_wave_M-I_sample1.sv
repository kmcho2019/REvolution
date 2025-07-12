module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_1;

    // Register freq-1 to reduce combinational subtraction delay
    always @(posedge clk) begin
        freq_minus_1 <= freq - 8'd1;
    end

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // If freq=0, hold output steady and reset counter
            count    <= 0;
            wave_out <= wave_out;
        end else if (count == freq_minus_1) begin
            count    <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule