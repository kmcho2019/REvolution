module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    reg toggle_flag;
    wire counter_done = (count == 0);
    
    // Continuous assignment with optimized freq=0 handling
    assign wave_out = (freq == 8'd0) ? 1'b0 : toggle_flag;
    
    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Handle freq=0 case efficiently
            toggle_flag <= 1'b0;
            count <= 8'd0;
        end
        else if (counter_done) begin
            toggle_flag <= ~toggle_flag;
            count <= freq - 1;  // Load (freq-1) for proper countdown
        end else begin
            count <= count - 1;  // Efficient down-counting
        end
    end

endmodule