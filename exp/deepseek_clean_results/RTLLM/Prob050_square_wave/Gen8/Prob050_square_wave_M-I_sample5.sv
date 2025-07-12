module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg toggle_reg;
    wire counter_enable = (freq != 8'd0);
    wire toggle_comb = counter_enable ? (count == freq) : 1'b1;

    always @(posedge clk) begin
        if (counter_enable) begin
            if (toggle_comb) begin
                count <= 8'd0;
            end else begin
                count <= count + 1;
            end
        end

        toggle_reg <= toggle_comb;
        if (toggle_reg) wave_out <= ~wave_out;
    end

endmodule