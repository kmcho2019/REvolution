module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire count_enable = |freq;  // Clock gating control
    wire terminal_count = (count == 8'd1);  // Detect terminal count early
    
    // Gray code counter conversion
    wire [7:0] next_count = terminal_count ? freq : (count - 1);
    wire [7:0] gray_count = next_count ^ (next_count >> 1);
    
    always @(posedge clk) begin
        if (count_enable) begin
            count <= gray_count;
            if (terminal_count) begin
                wave_out <= ~wave_out;  // Toggle output
            end
        end
        else begin
            count <= 8'b0;
            wave_out <= 1'b0;
        end
    end

endmodule