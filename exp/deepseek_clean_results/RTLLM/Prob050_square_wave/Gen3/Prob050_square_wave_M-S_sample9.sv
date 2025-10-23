module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // No toggling when freq=0
            wave_out <= 1'b0;
            count <= 0;
        end else if (count == 0) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end

endmodule