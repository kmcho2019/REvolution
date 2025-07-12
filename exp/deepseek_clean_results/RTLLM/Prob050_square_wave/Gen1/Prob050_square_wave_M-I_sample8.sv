module square_wave #(
    parameter COUNTER_WIDTH = 8
) (
    input clk,
    input [COUNTER_WIDTH-1:0] freq,
    output reg wave_out
);

    reg [COUNTER_WIDTH-1:0] count;

    always @(posedge clk) begin
        if (count == freq) begin
            wave_out <= ~wave_out;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule