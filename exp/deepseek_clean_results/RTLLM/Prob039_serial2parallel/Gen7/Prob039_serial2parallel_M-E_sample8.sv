module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Dual buffer architecture
    reg [7:0] buffer_A, buffer_B;
    reg buffer_select;  // 0 for A, 1 for B
    
    // One-hot counter (8 states)
    reg [7:0] bit_counter;
    wire counter_full = bit_counter[7];
    
    // Shadow register for clean output
    reg [7:0] shadow_reg;
    reg shadow_valid;
    
    // Pre-decoded write enables
    wire [7:0] write_mask = bit_counter;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer_A <= 8'b0;
            buffer_B <= 8'b0;
            buffer_select <= 1'b0;
            bit_counter <= 8'b00000001;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            shadow_reg <= 8'b0;
            shadow_valid <= 1'b0;
        end
        else begin
            // Default outputs
            dout_valid <= shadow_valid;
            
            // Handle data collection
            if (din_valid) begin
                // Update active buffer
                if (!buffer_select) begin
                    buffer_A <= (buffer_A & ~write_mask) | ({8{din_serial}} & write_mask);
                end
                else begin
                    buffer_B <= (buffer_B & ~write_mask) | ({8{din_serial}} & write_mask);
                end
                
                // Advance one-hot counter
                bit_counter <= {bit_counter[6:0], bit_counter[7]};
                
                // On full counter, switch buffers and output
                if (counter_full) begin
                    if (!buffer_select) begin
                        shadow_reg <= buffer_A;
                    end
                    else begin
                        shadow_reg <= buffer_B;
                    end
                    shadow_valid <= 1'b1;
                    buffer_select <= ~buffer_select;
                end
                else begin
                    shadow_valid <= 1'b0;
                end
            end
            else begin
                shadow_valid <= 1'b0;
            end
            
            // Update output from shadow register
            if (shadow_valid) begin
                dout_parallel <= shadow_reg;
            end
        end
    end

endmodule