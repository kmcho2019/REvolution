module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    wire counter_done = (count == 0);
    
    // Power-optimized output assignment
    assign wave_out = (freq == 0) ? 1'b0 : count[7];
    
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 8'd0;  // Hold at 0 when disabled
        end
        else if (counter_done) begin
            count <= freq;  // Reload with full frequency value
        end else begin
            count <= count - 1;  // Efficient down-counting
        end
    end

endmodule