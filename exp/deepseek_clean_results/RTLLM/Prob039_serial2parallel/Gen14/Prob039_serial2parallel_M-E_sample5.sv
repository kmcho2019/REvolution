module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;
    reg [2:0] read_ptr;
    reg [7:0] data_buffer;
    reg [3:0] bit_count;
    reg buffer_full;

    // Circular buffer write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 3'b0;
            bit_count <= 4'b0;
            buffer_full <= 1'b0;
            data_buffer <= 8'b0;
        end else if (din_valid && !buffer_full) begin
            // Store data at current write pointer
            data_buffer[write_ptr] <= din_serial;
            
            // Update pointers and counters
            write_ptr <= write_ptr + 1'b1;
            bit_count <= bit_count + 1'b1;
            
            // Check if buffer is full
            if (bit_count == 4'd7) begin
                buffer_full <= 1'b1;
            end
        end
    end

    // Output generation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            read_ptr <= 3'b0;
        end else begin
            dout_valid <= 1'b0;
            
            if (buffer_full) begin
                // Output the complete buffer contents in order
                dout_parallel <= data_buffer;
                dout_valid <= 1'b1;
                
                // Reset for next cycle
                buffer_full <= 1'b0;
                bit_count <= 4'b0;
                write_ptr <= 3'b0;
            end
        end
    end

endmodule