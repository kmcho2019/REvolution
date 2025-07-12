module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Circular buffer implementation
    reg [2:0] wr_ptr;         // Write pointer (0-7)
    reg [7:0] data_buffer;    // Circular buffer storage
    reg [7:0] valid_mask;     // Tracks which bits are valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'b0;
            data_buffer <= 8'b0;
            valid_mask <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default
            
            if (din_valid) begin
                // Update circular buffer
                data_buffer[wr_ptr] <= din_serial;
                valid_mask[wr_ptr] <= 1'b1;
                
                // Update output continuously
                dout_parallel[wr_ptr] <= din_serial;
                
                // Check if we have a complete word
                if (&valid_mask) begin
                    dout_valid <= 1'b1;
                    valid_mask <= 8'b0;  // Reset for next word
                end
                
                // Increment write pointer (wraps automatically)
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end

endmodule