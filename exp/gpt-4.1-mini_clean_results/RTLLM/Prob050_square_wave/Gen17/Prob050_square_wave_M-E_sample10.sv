module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_clamped;

    // Clamp freq to minimum 1 to avoid zero-count scenario
    assign freq_clamped = (freq == 8'd0) ? 8'd1 : freq;

    always @(posedge clk) begin
        if (count == 8'd0) begin
            count    <= freq_clamped;
            wave_out <= ~wave_out;
        end else begin
            count <= count - 1'b1;
        end
    end

    // Initialize registers
    initial begin
        count    = 8'd1;
        wave_out = 1'b0;
    end

endmodule