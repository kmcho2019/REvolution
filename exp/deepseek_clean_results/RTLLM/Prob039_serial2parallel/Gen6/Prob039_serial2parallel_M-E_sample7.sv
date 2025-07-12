module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Gray code pointer for low-power counting
    reg [2:0] wr_ptr_gray;
    wire [2:0] wr_ptr_bin;
    
    // Circular buffer storage
    reg [7:0] data_buffer;
    
    // Gray to binary conversion
    assign wr_ptr_bin[2] = wr_ptr_gray[2];
    assign wr_ptr_bin[1] = wr_ptr_bin[2] ^ wr_ptr_gray[1];
    assign wr_ptr_bin[0] = wr_ptr_bin[1] ^ wr_ptr_gray[0];
    
    // Binary to gray for next state
    wire [2:0] next_ptr_gray = {wr_ptr_bin[2], 
                               wr_ptr_bin[2] ^ wr_ptr_bin[1],
                               wr_ptr_bin[1] ^ wr_ptr_bin[0]};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray <= 3'b000;
            data_buffer <= 8'b0;
            dout_valid <= 1'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Update only the relevant bit in circular buffer
                data_buffer[wr_ptr_bin] <= din_serial;
                
                // Pre-compute parallel output
                dout_parallel <= {data_buffer[6:0], din_serial};
                
                // Check if we've collected all 8 bits
                if (wr_ptr_bin == 3'b111) begin
                    dout_valid <= 1'b1;
                end
                
                // Update gray-coded pointer
                wr_ptr_gray <= next_ptr_gray;
            end
        end
    end

endmodule