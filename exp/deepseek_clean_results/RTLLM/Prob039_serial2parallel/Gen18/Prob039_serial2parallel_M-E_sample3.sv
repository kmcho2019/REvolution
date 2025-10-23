module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;  // 3-bit pointer (0-7)
    reg [7:0] data_buffer [0:7];  // 8-entry buffer

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pointer and buffer
            write_ptr <= 3'b0;
            dout_valid <= 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                data_buffer[i] <= 1'b0;
            end
        end
        else begin
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Store current bit in circular buffer
                data_buffer[write_ptr] <= din_serial;

                // Update pointer with wrap-around
                if (write_ptr == 3'd7) begin
                    write_ptr <= 3'd0;
                    dout_valid <= 1'b1;
                    
                    // Generate parallel output by reading all buffer locations
                    for (i = 0; i < 8; i = i + 1) begin
                        dout_parallel[i] <= data_buffer[i];
                    end
                end
                else begin
                    write_ptr <= write_ptr + 1'b1;
                end
            end
        end
    end

endmodule