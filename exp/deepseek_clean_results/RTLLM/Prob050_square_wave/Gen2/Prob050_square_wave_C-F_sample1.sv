module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire count_done = (count == 0);
    
    always @(posedge clk) begin
        if (freq == 0) begin
            // Handle zero frequency case
            wave_out <= 0;
            count <= 0;
        end else if (count_done) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq - 1;
        end else begin
            // Count down
            count <= count - 1;
        end
    end

    // Reset handling (optional - can be added as input if needed)
    initial begin
        wave_out = 0;
        count = 0;
    end

endmodule