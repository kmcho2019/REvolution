module square_wave #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] freq,
    output reg wave_out = 0
);

    reg [WIDTH-1:0] count = 0;
    reg freq_zero = 0;

    // Detect freq=0 condition only when freq changes
    always @(freq) begin
        freq_zero <= (freq == 0);
    end

    always @(posedge clk) begin
        if (freq_zero) begin
            // Special case: no output when freq=0
            wave_out <= 0;
            count <= 0;
        end else if (count == freq - 1) begin
            // Toggle output and reset counter
            wave_out <= ~wave_out;
            count <= 0;
        end else begin
            // Increment counter
            count <= count + 1;
        end
    end

endmodule