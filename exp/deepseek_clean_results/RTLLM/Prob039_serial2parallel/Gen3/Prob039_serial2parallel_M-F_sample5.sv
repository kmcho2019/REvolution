module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;  // Circular write pointer (0-7)
    reg [7:0] buffer;     // Circular buffer storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 3'b0;
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            // Store incoming data
            if (din_valid) begin
                buffer[write_ptr] <= din_serial;
                
                // Update pointer (wraps after 7)
                if (write_ptr == 3'd7) begin
                    write_ptr <= 3'b0;
                    dout_valid <= 1'b1;
                    dout_parallel <= buffer;  // Output the complete buffer
                end
                else begin
                    write_ptr <= write_ptr + 1'b1;
                end
            end
        end
    end

endmodule