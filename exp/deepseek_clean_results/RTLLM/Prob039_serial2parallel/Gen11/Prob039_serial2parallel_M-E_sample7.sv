module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] data_buffer;
    reg [2:0] write_ptr;  // 3-bit pointer (0-7)
    reg buffer_full;

    // Circular buffer write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            write_ptr <= 3'b0;
            buffer_full <= 1'b0;
        end
        else if (din_valid) begin
            // Write data at current pointer position
            data_buffer[7-write_ptr] <= din_serial;
            
            // Update pointer and full flag
            if (write_ptr == 3'd7) begin
                write_ptr <= 3'b0;
                buffer_full <= 1'b1;
            end
            else begin
                write_ptr <= write_ptr + 1;
                buffer_full <= 1'b0;
            end
        end
        else begin
            buffer_full <= 1'b0;
        end
    end

    // Output generation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= buffer_full;
            if (buffer_full) begin
                dout_parallel <= data_buffer;
            end
        end
    end

endmodule