module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one = freq - 1;
    wire freq_nonzero = |freq; // Check if freq is nonzero (avoid zero freq)

    always @(posedge clk) begin
        if (freq_nonzero) begin
            if (count == freq_minus_one) begin
                count <= 0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1;
            end
        end else begin
            // Hold outputs steady if freq is zero to avoid continuous toggling
            count <= 0;
            wave_out <= wave_out;
        end
    end

endmodule