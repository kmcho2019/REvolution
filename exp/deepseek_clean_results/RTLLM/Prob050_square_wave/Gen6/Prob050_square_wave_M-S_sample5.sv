module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            count <= 0;
        end else if (count == 0) begin
            wave_out <= ~wave_out;
            count <= freq - 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule