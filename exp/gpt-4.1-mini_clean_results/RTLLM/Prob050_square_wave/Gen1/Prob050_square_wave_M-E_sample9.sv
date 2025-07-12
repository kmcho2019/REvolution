module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] half_period;

    always @(posedge clk) begin
        // Compute half period (freq/2) each clock cycle for toggle comparison
        half_period <= freq >> 1;

        if (count >= half_period && half_period != 0) begin
            count    <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule