module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg toggle_flag;
    wire counter_done = (count == 0) || (freq == 0);
    
    // Continuous assignment for clean output
    assign wave_out = (freq == 0) ? 1'b0 : toggle_flag;
    
    // Optimized counter control
    always @(posedge clk) begin
        if (counter_done) begin
            toggle_flag <= (freq == 0) ? 1'b0 : ~toggle_flag;
            count <= freq[6:0];  // Reload with current frequency
        end else begin
            count <= count - 1;  // Efficient down-counting
        end
    end

endmodule