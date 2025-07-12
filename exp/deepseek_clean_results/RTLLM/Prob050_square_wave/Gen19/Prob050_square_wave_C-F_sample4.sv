module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_done = (count == 0);
    wire active = (freq != 0);

    always @(posedge clk) begin
        if (!active) begin
            wave_out <= 1'b0;
            count <= 0;
        end
        else begin
            if (count_done) begin
                wave_out <= ~wave_out;
                count <= freq - 1;
            end
            else begin
                count <= count - 1;
            end
        end
    end

endmodule