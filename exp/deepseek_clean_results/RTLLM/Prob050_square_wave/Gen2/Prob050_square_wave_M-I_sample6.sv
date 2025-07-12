module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg toggle;
    wire count_enable = (freq != 0);

    always @(posedge clk) begin
        if (count_enable) begin
            if (count == 0) begin
                toggle <= 1'b1;
                count <= freq;
            end else begin
                toggle <= 1'b0;
                count <= count - 1;
            end
        end
    end

    always @(posedge clk) begin
        if (toggle && count_enable) begin
            wave_out <= ~wave_out;
        end
    end

endmodule