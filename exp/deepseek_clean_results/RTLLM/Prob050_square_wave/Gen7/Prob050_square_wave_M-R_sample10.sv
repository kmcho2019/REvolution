module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_max = (count == freq) && (freq != 0);

    always @(posedge clk) begin
        if (count_max) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule