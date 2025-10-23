module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire count_done = (count == 0);
    wire valid_freq = (freq != 0);

    always @(posedge clk) begin
        if (!valid_freq) begin
            // Clock gating for zero frequency case
            count <= 0;
        end else if (count_done) begin
            // Toggle only when counter completes
            wave_out <= ~wave_out;
            count <= freq - 1; // Initialize down-counter
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end

    // Initialize counter
    initial begin
        count = 0;
        wave_out = 0;
    end

endmodule