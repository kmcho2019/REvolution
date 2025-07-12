module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg prev_freq = 8'd0;
reg clk_enable = 1'b1; // Default clock enable

always @(posedge clk) begin
    if (freq !== prev_freq) begin
        prev_freq <= freq;
        count <= 8'd0; // Reset counter when frequency changes
        clk_enable <= 1'b1; // Enable clock when frequency changes
    end
    
    if (clk_enable) begin
        if (count == (freq - 1)) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
        
        // Optional: Dynamic clock gating based on frequency stability
        // Since we don't have additional signals to indicate frequency stability,
        // this part is not directly implemented. However, in practice, you would
        // use logic here to set clk_enable based on whether the frequency input
        // has been stable for a certain number of cycles, potentially reducing
        // power consumption by disabling the clock when the output is not changing.
    end
end

endmodule