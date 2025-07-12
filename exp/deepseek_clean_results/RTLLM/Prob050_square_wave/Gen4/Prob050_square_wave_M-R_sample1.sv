module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire terminal_count;
    
    // Terminal count is reached when counter equals (freq-1)
    assign terminal_count = (freq != 0) && (count == (freq - 1));

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: no output when freq=0
            wave_out <= 0;
            count <= 0;
        end else begin
            // Counter logic
            count <= terminal_count ? 0 : (count + 1);
            
            // Toggle output on terminal count
            wave_out <= terminal_count ? ~wave_out : wave_out;
        end
    end

endmodule