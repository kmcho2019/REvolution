module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire freq_valid = |freq;  // Check if freq is non-zero

    always @(posedge clk) begin
        if (freq_valid) begin
            if (count == (freq - 1)) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end
            else begin
                count <= count + 1;
            end
        end
        else begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end
    end

endmodule