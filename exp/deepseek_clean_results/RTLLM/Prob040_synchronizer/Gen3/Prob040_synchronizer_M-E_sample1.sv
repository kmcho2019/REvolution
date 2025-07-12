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
    reg [3:0] fifo [0:1];
    
    // Write domain (clk_a)
    reg [1:0] wptr;
    reg [1:0] wptr_gray;
    reg [1:0] wptr_gray_sync_b1, wptr_gray_sync_b2;
    
    // Read domain (clk_b)
    reg [1:0] rptr;
    reg [1:0] rptr_gray;
    reg [1:0] rptr_gray_sync_a1, rptr_gray_sync_a2;
    
    // FIFO control signals
    wire fifo_full;
    wire fifo_empty;
    
    // Gray code conversion functions
    function [1:0] bin2gray(input [1:0] bin);
        bin2gray = {bin[1], bin[1] ^ bin[0]};
    endfunction
    
    function [1:0] gray2bin(input [1:0] gray);
        gray2bin = {gray[1], gray[1] ^ gray[0]};
    endfunction
    
    // Write pointer logic (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            wptr <= 2'b00;
            wptr_gray <= 2'b00;
        end else if (data_en && !fifo_full) begin
            fifo[wptr[0]] <= data_in;  // Store data in FIFO
            wptr <= wptr + 1;          // Increment write pointer
            wptr_gray <= bin2gray(wptr + 1);  // Convert to gray code
        end
    end
    
    // Synchronize write pointer to read domain (clk_b)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            wptr_gray_sync_b1 <= 2'b00;
            wptr_gray_sync_b2 <= 2'b00;
        end else begin
            wptr_gray_sync_b1 <= wptr_gray;
            wptr_gray_sync_b2 <= wptr_gray_sync_b1;
        end
    end
    
    // Read pointer logic (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            rptr <= 2'b00;
            rptr_gray <= 2'b00;
            dataout <= 4'b0;
        end else if (!fifo_empty) begin
            dataout <= fifo[rptr[0]];   // Read data from FIFO
            rptr <= rptr + 1;           // Increment read pointer
            rptr_gray <= bin2gray(rptr + 1);  // Convert to gray code
        end
    end
    
    // Synchronize read pointer to write domain (clk_a)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            rptr_gray_sync_a1 <= 2'b00;
            rptr_gray_sync_a2 <= 2'b00;
        end else begin
            rptr_gray_sync_a1 <= rptr_gray;
            rptr_gray_sync_a2 <= rptr_gray_sync_a1;
        end
    end
    
    // FIFO status signals
    assign fifo_full = (wptr == (gray2bin(rptr_gray_sync_a2) ^ 2'b10));
    assign fifo_empty = (gray2bin(wptr_gray_sync_b2) == rptr);
    
endmodule