module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire toggle = (count == 8'd0) && (freq != 0);
    wire counter_enable = (freq != 0);  // Clock gating for freq=0 case
    wire [7:0] next_count = toggle ? (freq - 1) : (count - 1);

    always @(posedge clk) begin
        if (counter_enable) begin
            count <= next_count;
            if (toggle) wave_out <= ~wave_out;
        end
        // Special case: freq=0 means constant output
        if (freq == 0) wave_out <= 1'b0;
    end

endmodule