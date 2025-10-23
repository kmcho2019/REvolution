module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    reg data_ready;
    reg ack_sync_a;
    
    // clk_b domain signals
    reg ready_sync1, ready_sync2;
    reg ack_reg;
    reg ack_sync1, ack_sync2;
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_ready <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            // Synchronize ack from clk_b domain
            ack_sync_a <= ack_sync2;
            
            // Handle new data transfer
            if (data_en && !data_ready && !ack_sync_a) begin
                data_reg <= data_in;
                data_ready <= 1'b1;
            end 
            // Clear ready when ack is received
            else if (data_ready && ack_sync_a) begin
                data_ready <= 1'b0;
            end
        end
    end

    // Synchronize ready to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ready_sync1 <= 1'b0;
            ready_sync2 <= 1'b0;
        end else begin
            ready_sync1 <= data_ready;
            ready_sync2 <= ready_sync1;
        end
    end

    // Generate ack in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_reg <= 1'b0;
        end else begin
            // Generate ack when we see a new ready
            ack_reg <= ready_sync2 && !ack_reg;
        end
    end

    // Synchronize ack back to clk_a domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_sync1 <= 1'b0;
            ack_sync2 <= 1'b0;
        end else begin
            ack_sync1 <= ack_reg;
            ack_sync2 <= ack_sync1;
        end
    end

    // Output data register in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (ready_sync2 && !ack_reg) begin
            dataout <= data_reg;
        end
    end

endmodule