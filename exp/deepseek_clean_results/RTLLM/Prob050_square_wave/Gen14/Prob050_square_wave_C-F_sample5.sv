module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire counter_max = (freq != 0) && (count == (freq - 1));
    wire [7:0] next_count = counter_max ? 8'd0 : (count + 1);
    wire next_wave = counter_max ? ~wave_out : 
                    (freq == 0) ? 1'b0 : wave_out;

    always @(posedge clk) begin
        count <= next_count;
        wave_out <= next_wave;
    end

endmodule