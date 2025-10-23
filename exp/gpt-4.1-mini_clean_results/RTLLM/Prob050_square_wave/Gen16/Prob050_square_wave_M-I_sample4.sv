module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire clk_en = (freq > 8'd1);
    wire toggle_condition = clk_en && (count == freq - 1);

    always @(posedge clk) begin
        if (clk_en) begin
            if (toggle_condition) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and output steady when freq <= 1
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule