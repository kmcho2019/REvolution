module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [6:0] count;
    wire terminal_count = (count == 0);
    
    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: zero frequency means constant low
            wave_out <= 1'b0;
            count <= 7'd0;
        end
        else if (terminal_count) begin
            // End of period - toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq[6:0];
        end
        else begin
            // Normal counting
            count <= count - 1;
        end
    end

endmodule