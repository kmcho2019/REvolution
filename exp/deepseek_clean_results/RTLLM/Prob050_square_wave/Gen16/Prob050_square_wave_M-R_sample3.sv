module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_max = (count == (freq - 1));

    // Counter logic
    always @(posedge clk) begin
        if (freq == 0)
            count <= 8'd0;
        else if (count_max)
            count <= 8'd0;
        else
            count <= count + 1;
    end

    // Wave generation logic
    always @(posedge clk) begin
        if (freq == 0)
            wave_out <= 1'b0;
        else if (count_max)
            wave_out <= ~wave_out;
    end

endmodule