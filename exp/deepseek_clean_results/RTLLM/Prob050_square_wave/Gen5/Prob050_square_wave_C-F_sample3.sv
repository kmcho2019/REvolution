module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count = 0;
    reg toggle = 0;
    wire terminal_count = (count == (freq - 1)) || (freq == 0);
    
    // Efficient incrementing counter
    always @(posedge clk) begin
        count <= terminal_count ? 8'd0 : (count + 1);
    end
    
    // Power-optimized toggle logic
    always @(posedge clk) begin
        if (terminal_count && freq != 0) begin
            toggle <= ~toggle;
        end
    end
    
    // Clean output assignment
    assign wave_out = (freq == 0) ? 1'b0 : toggle;

endmodule