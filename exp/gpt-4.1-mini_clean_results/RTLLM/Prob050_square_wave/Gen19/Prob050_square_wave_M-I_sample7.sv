module square_wave (
    input  wire        clk,
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    // Clock enable: count only if freq != 0
    wire ce = (freq != 8'd0);

    always @(posedge clk) begin
        if (ce) begin
            if (count == freq - 1) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count <= 8'd0;       // Hold count at zero when disabled
            // Hold wave_out steady when freq is zero
            wave_out <= wave_out;
        end
    end

    // Initialize registers (optional, for simulation)
    initial begin
        count    = 8'd0;
        wave_out = 1'b0;
    end

endmodule