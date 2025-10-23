module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] buffer;
    reg [2:0] bit_ptr;  // Pointer instead of counter
    reg buffer_full;
    
    // Clock gating enable
    wire buffer_update = din_valid & ~buffer_full;
    
    // Combinatorial valid signal
    assign dout_valid = buffer_full;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            bit_ptr <= 3'b0;
            buffer_full <= 1'b0;
        end
        else begin
            // Update buffer only when needed
            if (buffer_update) begin
                buffer[bit_ptr] <= din_serial;
                
                if (bit_ptr == 3'd7) begin
                    bit_ptr <= 3'b0;
                    buffer_full <= 1'b1;
                    dout_parallel <= buffer;  // Will update with new bit next cycle
                end
                else begin
                    bit_ptr <= bit_ptr + 1'b1;
                end
            end
            else if (buffer_full) begin
                // Clear full flag after one cycle
                buffer_full <= 1'b0;
                // Update output with complete word (now includes the 8th bit)
                dout_parallel <= {buffer[6:0], din_serial};
            end
        end
    end

endmodule