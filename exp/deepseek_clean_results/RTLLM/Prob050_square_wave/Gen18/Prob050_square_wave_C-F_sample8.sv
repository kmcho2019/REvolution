module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;  // Static low output when freq=0
            count <= 0;        // Reset counter
        end
        else if (count == 0) begin
            count <= freq - 1; // Reload counter
            wave_out <= ~wave_out;  // Toggle output
        end
        else begin
            count <= count - 1;  // Decrement counter
        end
    end

endmodule