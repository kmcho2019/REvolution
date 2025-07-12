module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_reset = (count == (freq - 1)) || (freq == 0);
    wire [7:0] next_count = count_reset ? 8'd0 : count + 8'd1;
    wire next_wave = (freq == 0) ? 1'b0 : (count_reset ? ~wave_out : wave_out);

    always @(posedge clk) begin
        count <= next_count;
        wave_out <= next_wave;
    end

endmodule