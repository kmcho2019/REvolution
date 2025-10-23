module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] data_buffer;      // Circular buffer storage
    reg [2:0] wptr;             // Write pointer (0-7)
    wire buffer_full = (wptr == 3'd7) & din_valid;

    // Combinatorial output valid
    assign dout_valid = buffer_full;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_buffer <= 8'b0;
            wptr <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            if (din_valid) begin
                // Store input at current pointer position
                data_buffer[wptr] <= din_serial;
                
                // Update write pointer (circular)
                wptr <= wptr + 1'b1;

                // Capture parallel output when buffer is full
                if (buffer_full) begin
                    dout_parallel <= data_buffer;
                    // Note: We keep the old data_buffer value until next write
                end
            end
        end
    end

endmodule