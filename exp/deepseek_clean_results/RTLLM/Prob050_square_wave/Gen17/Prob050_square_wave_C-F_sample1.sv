module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_enable = (freq != 0);  // Clock enable for power savings

    always @(posedge clk) begin
        if (count_enable) begin
            if (count == (freq - 1)) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end
            else begin
                count <= count + 1;
            end
        end
        else begin  // freq=0 case
            count <= 8'd0;
            wave_out <= 1'b0;
        end
    end

endmodule