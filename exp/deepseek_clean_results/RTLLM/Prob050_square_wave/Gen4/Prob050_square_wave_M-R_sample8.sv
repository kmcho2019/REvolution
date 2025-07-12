module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire counter_max = (count == (freq - 1)) || (freq == 0);
    wire next_count = counter_max ? 8'd0 : (count + 1);
    wire next_wave = (freq == 0) ? 1'b0 : (counter_max ? ~wave_out : wave_out);

    always @(posedge clk) begin
        count <= next_count;
        wave_out <= next_wave;
    end

endmodule