module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // If frequency is zero, output stays at 0 (or undefined behavior)
            wave_out <= 1'b0;
            count <= 8'b0;
        end else if (count == (freq - 1)) begin
            // Toggle wave and reset counter when count reaches (freq - 1)
            wave_out <= ~wave_out;
            count <= 8'b0;
        end else begin
            // Otherwise, just increment the counter
            count <= count + 1;
        end
    end

endmodule