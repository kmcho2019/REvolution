module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg toggle;
    wire counter_enable = (freq > 0);  // Simple enable for non-zero frequencies
    
    // Combinational output assignment
    assign wave_out = toggle;
    
    // Optimized counter control
    always @(posedge clk) begin
        if (counter_enable) begin
            if (count == 0) begin
                toggle <= ~toggle;
                count <= freq[6:0];  // Direct reload without subtraction
            end else begin
                count <= count - 1;  // Efficient down-counting
            end
        end
    end

endmodule