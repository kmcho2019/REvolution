module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_max = (freq != 0) && (count == (freq - 1));
    wire [7:0] next_count = count_max ? 8'd0 : (count + 1);
    wire next_wave = count_max ? ~wave_out : wave_out;

    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            count <= 8'd0;
        end else begin
            count <= next_count;
            wave_out <= next_wave;
        end
    end

endmodule