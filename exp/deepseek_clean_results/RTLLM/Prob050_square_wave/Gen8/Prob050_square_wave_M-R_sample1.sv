module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire terminal_count = (count == freq);

    always @(posedge clk) begin
        if (terminal_count) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule