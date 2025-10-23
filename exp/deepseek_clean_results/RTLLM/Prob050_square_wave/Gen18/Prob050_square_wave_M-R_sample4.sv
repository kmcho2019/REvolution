module square_wave (
    input clk,
    input [7:0] freq,
    output wire wave_out
);

    reg [7:0] count = 0;
    reg wave_reg = 0;

    // Use combinational assign for freq=0 case (constant low)
    assign wave_out = (freq == 0) ? 1'b0 : wave_reg;

    always @(posedge clk) begin
        if (freq != 0) begin
            if (count == (freq - 1)) begin
                count <= 8'd0;
                wave_reg <= ~wave_reg;
            end
            else begin
                count <= count + 1;
            end
        end
        else begin
            // Keep counter reset when freq=0
            count <= 8'd0;
        end
    end

endmodule