module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (count == 0) begin
            wave_out <= ~wave_out;
            count <= freq;
        end else begin
            count <= count - 1;
        end
    end

endmodule