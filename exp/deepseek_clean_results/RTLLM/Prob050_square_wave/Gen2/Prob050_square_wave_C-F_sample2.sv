module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: no output when freq=0
            wave_out <= 0;
            count <= 0;
        end else if (count == 1) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq;
        end else begin
            // Decrement counter (or load if currently 0)
            count <= (count == 0) ? freq : (count - 1);
        end
    end

endmodule