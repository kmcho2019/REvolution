module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] data_buffer;
    reg [2:0] write_ptr;
    reg buffer_full;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            write_ptr <= 3'b0;
            buffer_full <= 1'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default outputs
            dout_valid <= 1'b0;

            // Serial data collection
            if (din_valid) begin
                // Store current bit at pointer position
                data_buffer[write_ptr] <= din_serial;
                
                // Update pointer (wraps around after 7)
                write_ptr <= write_ptr + 1'b1;
                
                // Set full flag when pointer wraps
                buffer_full <= (write_ptr == 3'd7);
            end

            // Parallel output generation
            if (buffer_full) begin
                dout_parallel <= data_buffer;
                dout_valid <= 1'b1;
                buffer_full <= 1'b0;
            end
        end
    end

endmodule