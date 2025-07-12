module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 1'b0
);

reg [7:0] count = 8'b0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out;  
        count <= 8'b0;  
    end else begin
        count <= count + 1;  
    end
end

endmodule