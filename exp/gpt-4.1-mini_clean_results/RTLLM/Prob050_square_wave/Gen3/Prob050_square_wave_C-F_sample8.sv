module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Hold outputs steady when frequency is zero (no toggling)
            count <= 0;
            wave_out <= wave_out;
        end else if (count == freq) begin
            // Toggle wave_out and reset count when count matches freq
            count <= 0;
            wave_out <= ~wave_out;
        end else begin
            // Increment counter otherwise
            count <= count + 1;
        end
    end

endmodule