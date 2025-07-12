module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;          // Circular buffer for serial data
    reg [2:0] bit_ptr;         // Pointer for circular buffer (0-7)
    reg [2:0] bit_count;       // Counter for received bits (0-7)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            bit_ptr <= 3'b0;
            bit_count <= 3'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default outputs
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Store incoming bit in circular buffer
                buffer[bit_ptr] <= din_serial;
                
                // Update pointer and counter
                bit_ptr <= (bit_ptr == 3'd7) ? 3'b0 : bit_ptr + 1'b1;
                bit_count <= (bit_count == 3'd7) ? 3'b0 : bit_count + 1'b1;
                
                // Output complete byte when counter wraps
                if (bit_count == 3'd7) begin
                    dout_parallel <= buffer;
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule