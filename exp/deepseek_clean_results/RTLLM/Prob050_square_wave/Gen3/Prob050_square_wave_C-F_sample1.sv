module square_wave #(
    parameter COUNTER_WIDTH = 8,
    parameter HANDLE_ZERO_FREQ = 0  // Set to 1 to handle freq=0 case
) (
    input clk,
    input [COUNTER_WIDTH-1:0] freq,
    output reg wave_out = 0
);

    reg [COUNTER_WIDTH-1:0] count = 0;

    generate
        if (HANDLE_ZERO_FREQ) begin
            // Version with zero frequency handling (slightly slower)
            always @(posedge clk) begin
                if (freq == 0) begin
                    count <= 0;
                end else if (count == freq) begin
                    wave_out <= ~wave_out;
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end
        end else begin
            // Optimized version (no zero frequency check)
            always @(posedge clk) begin
                if (count == freq) begin
                    wave_out <= ~wave_out;
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end
        end
    endgenerate

endmodule