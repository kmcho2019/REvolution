module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_one;

    // Register freq_minus_one to reduce combinational path for subtraction in comparison
    always @(posedge clk) begin
        freq_minus_one <= freq - 1;
    end

    always @(posedge clk) begin
        if (freq == 0) begin
            // Hold output steady and reset count when freq=0 to avoid toggle
            count <= 0;
            wave_out <= wave_out; // maintain current state
        end else if (count == freq_minus_one) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule