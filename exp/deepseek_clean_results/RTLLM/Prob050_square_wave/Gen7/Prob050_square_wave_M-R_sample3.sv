module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire counter_load = (count == freq) || (freq == 8'd0);
    wire wave_toggle = (count == freq) && (freq != 8'd0);

    always @(posedge clk) begin
        if (counter_load) begin
            count <= 8'd1;  // Load 1 instead of 0 for simpler comparison
        end else begin
            count <= count + 1;
        end

        if (wave_toggle) begin
            wave_out <= ~wave_out;
        end
    end

endmodule