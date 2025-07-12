module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] clk_div;

    always @(posedge clk) begin
        if (clk_div == freq) begin
            wave_out <= ~wave_out;
            clk_div <= 0;
        end else begin
            clk_div <= clk_div + 1;
        end
    end

endmodule