module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // FIFO memory (depth=2)
    reg [3:0] fifo_mem [0:1];
    
    // clk_a domain signals
    reg [1:0] wptr_a;       // Binary write pointer
    reg [1:0] wptr_gray_a;  // Gray code write pointer
    reg [1:0] rptr_sync_a;  // Synchronized read pointer
    
    // clk_b domain signals
    reg [1:0] rptr_b;       // Binary read pointer
    reg [1:0] rptr_gray_b;  // Gray code read pointer
    reg [1:0] wptr_sync_b;  // Synchronized write pointer
    
    // Binary to gray code conversion
    function [1:0] bin2gray;
        input [1:0] bin;
        begin
            bin2gray = {bin[1], bin[1] ^ bin[0]};
        end
    endfunction
    
    // Gray code to binary conversion
    function [1:0] gray2bin;
        input [1:0] gray;
        begin
            gray2bin = {gray[1], gray[1] ^ gray[0]};
        end
    endfunction
    
    // FIFO write logic (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            wptr_a <= 2'b00;
            wptr_gray_a <= 2'b00;
        end else if (data_en) begin
            // Write data to FIFO
            fifo_mem[wptr_a[0]] <= data_in;
            
            // Update pointers
            wptr_a <= wptr_a + 1'b1;
            wptr_gray_a <= bin2gray(wptr_a + 1'b1);
        end
    end
    
    // Synchronize read pointer to clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            rptr_sync_a <= 2'b00;
        end else begin
            rptr_sync_a <= rptr_gray_b;
        end
    end
    
    // Synchronize write pointer to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            wptr_sync_b <= 2'b00;
        end else begin
            wptr_sync_b <= wptr_gray_a;
        end
    end
    
    // FIFO read logic (clk_b domain)
    wire fifo_empty = (gray2bin(wptr_sync_b) == rptr_b;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            rptr_b <= 2'b00;
            rptr_gray_b <= 2'b00;
            dataout <= 4'b0;
        end else if (!fifo_empty) begin
            // Read data from FIFO
            dataout <= fifo_mem[rptr_b[0]];
            
            // Update pointers
            rptr_b <= rptr_b + 1'b1;
            rptr_gray_b <= bin2gray(rptr_b + 1'b1);
        end
    end

endmodule