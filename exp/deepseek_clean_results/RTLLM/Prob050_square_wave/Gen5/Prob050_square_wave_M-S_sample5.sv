module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (counter >= freq) begin
            wave_out <= ~wave_out;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule