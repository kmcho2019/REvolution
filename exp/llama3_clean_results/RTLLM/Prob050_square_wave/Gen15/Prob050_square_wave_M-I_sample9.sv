module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg clk_enable = 1'b1; // Added for clock gating

always @(posedge clk) begin
    if (clk_enable) begin // Apply clock gating
        if (count == freq - 1) begin // Adjusted condition to match the freq requirement
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end
end

// Simple logic to control clock gating based on frequency
always @(posedge clk) begin
    if (freq == 8'd0) begin
        clk_enable <= 1'b0; // Disable clock when frequency is 0
    end else begin
        clk_enable <= 1'b1; // Enable clock otherwise
    end
end

endmodule