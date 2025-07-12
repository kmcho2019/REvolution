module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire counter_max = (count == (freq - 1)) | (freq == 0);

    always @(posedge clk) begin
        if (counter_max) begin
            count <= 8'd0;
            wave_out <= (freq == 0) ? 1'b0 : ~wave_out;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule