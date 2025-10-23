module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Handle special case of zero frequency (output stays at 0)
            wave_out <= 1'b0;
            count <= 0;
        end else if (count == freq - 1) begin
            // Toggle output and reset counter when count reaches freq-1
            wave_out <= ~wave_out;
            count <= 0;
        end else begin
            // Otherwise just increment counter
            count <= count + 1;
        end
    end

endmodule