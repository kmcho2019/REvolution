module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg enable = 0;
    
    // Counter control logic
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
            enable <= 0;
        end else begin
            enable <= 1;
            if (count == 0)
                count <= freq - 1;
            else
                count <= count - 1;
        end
    end
    
    // Wave generation logic
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
        end else if (enable && (count == 0)) begin
            wave_out <= ~wave_out;
        end
    end

endmodule