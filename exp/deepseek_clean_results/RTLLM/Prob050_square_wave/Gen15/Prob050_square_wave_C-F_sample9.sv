module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_max = (count == (freq - 1));
    wire count_reset = (freq == 0) || count_max;
    
    always @(posedge clk) begin
        if (count_reset) begin
            count <= 8'd0;
            if (freq != 0) wave_out <= ~wave_out;
        end
        else begin
            count <= count + 1;
        end
        
        if (freq == 0) wave_out <= 1'b0;
    end

endmodule