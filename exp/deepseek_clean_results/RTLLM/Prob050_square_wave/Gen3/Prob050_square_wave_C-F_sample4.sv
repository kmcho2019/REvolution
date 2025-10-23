module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            // No output when freq=0
            wave_out <= 0;
            count <= 0;
        end else if (count == 0) begin
            // Reload counter and toggle output
            wave_out <= ~wave_out;
            count <= freq - 1;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end

endmodule