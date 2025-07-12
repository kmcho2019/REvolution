module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid,
    output wire ready
);

    reg [3:0] bit_cnt;
    reg [7:0] buffer_reg;
    reg next_valid;
    
    // Ready signal indicates we can accept new data
    assign ready = (bit_cnt != 4'd8);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'd0;
            buffer_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
            next_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;
            next_valid <= 1'b0;
            
            if (din_valid && ready) begin
                // Pre-shift operation
                buffer_reg <= {buffer_reg[6:0], din_serial};
                
                // Counter logic with early valid indication
                if (bit_cnt == 4'd6) begin
                    next_valid <= 1'b1;  // Signal valid next cycle
                end
                
                if (bit_cnt == 4'd7) begin
                    // Transfer buffer to output
                    dout_parallel <= {buffer_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    bit_cnt <= 4'd0;
                end
                else begin
                    bit_cnt <= bit_cnt + 4'd1;
                end
            end
            else if (next_valid) begin
                // Finalize the output transfer
                dout_parallel <= buffer_reg;
                dout_valid <= 1'b1;
            end
        end
    end

endmodule