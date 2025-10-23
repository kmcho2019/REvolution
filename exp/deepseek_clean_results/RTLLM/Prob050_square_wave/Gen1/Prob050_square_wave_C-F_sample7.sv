module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_1;

    initial begin
        wave_out = 0;
        count = 0;
        freq_minus_1 = 0;
    end

    always @(posedge clk) begin
        freq_minus_1 <= freq - 1;  // Pre-compute to reduce critical path
        
        if (freq == 0) begin
            count <= 0;
        end else if (count == freq_minus_1) begin
            wave_out <= ~wave_out;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule