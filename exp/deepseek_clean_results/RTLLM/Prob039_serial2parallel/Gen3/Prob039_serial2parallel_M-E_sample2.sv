module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] data_shift;   // Data shift register
    reg [7:0] track_shift;  // Tracking shift register (thermometer code)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_shift <= 8'b0;
            track_shift <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default outputs
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Shift in new data bit (MSB first)
                data_shift <= {data_shift[6:0], din_serial};
                
                // Update tracking shift register
                track_shift <= {track_shift[6:0], 1'b1};
                
                // Check for completion
                if (track_shift[7]) begin
                    dout_parallel <= {data_shift[6:0], din_serial};
                    dout_valid <= 1'b1;
                    track_shift <= 8'b0;  // Reset tracking
                end
            end
        end
    end

endmodule