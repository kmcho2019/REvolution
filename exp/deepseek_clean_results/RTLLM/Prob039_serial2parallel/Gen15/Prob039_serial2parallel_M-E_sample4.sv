module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] wr_ptr;
    reg [7:0] data_buffer;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'd0;
            data_buffer <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Store incoming bit at current pointer position
                data_buffer[wr_ptr] <= din_serial;
                
                // Update write pointer
                if (wr_ptr == 3'd7) begin
                    wr_ptr <= 3'd0;
                    // Output the complete buffer
                    dout_parallel <= data_buffer;
                    dout_valid <= 1'b1;
                    // Store new bit in position 0 for next cycle
                    data_buffer[0] <= din_serial;
                end
                else begin
                    wr_ptr <= wr_ptr + 3'd1;
                end
            end
        end
    end

endmodule