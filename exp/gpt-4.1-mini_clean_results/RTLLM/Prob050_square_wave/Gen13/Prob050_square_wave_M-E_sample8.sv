module square_wave (
    input  wire        clk,
    input  wire        rst,      // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    wire [7:0] half_freq = freq >> 1;

    // Free-running counter with wrap-around
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end

    // Generate wave_out combinationally from count and freq
    // When freq=0, output low (no toggling)
    always @(*) begin
        if (freq == 8'd0)
            wave_out = 1'b0;
        else
            wave_out = (count < half_freq) ? 1'b1 : 1'b0;
    end

endmodule