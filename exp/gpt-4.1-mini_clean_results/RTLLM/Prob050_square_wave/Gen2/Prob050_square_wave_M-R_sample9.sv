module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle_enable;

    // Generate toggle enable when count reaches freq - 1
    assign toggle_enable = (count == freq - 1);

    always @(posedge clk) begin
        if (toggle_enable) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule