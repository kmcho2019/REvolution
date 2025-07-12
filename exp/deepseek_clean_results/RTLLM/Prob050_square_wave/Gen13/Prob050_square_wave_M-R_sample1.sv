module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count = 0;
    reg wave_reg = 0;
    
    assign wave_out = (freq == 0) ? 1'b0 : wave_reg;

    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
            wave_reg <= 0;
        end
        else if (count == (freq - 1)) begin
            count <= 0;
            wave_reg <= ~wave_reg;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule