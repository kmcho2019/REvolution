module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] data_reg;
    reg data_en_prev;
    wire data_en_rise;
    reg req_sync;
    reg ack_sync_a;
    
    // Clock domain B signals
    reg req_sync_b1;
    reg req_sync_b2;
    reg ack_sync;
    reg [3:0] data_buf;
    
    // Edge detection in clk_a domain
    assign data_en_rise = data_en && !data_en_prev;
    
    // Clock domain A: Data capture and request generation
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_en_prev <= 1'b0;
            req_sync <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            
            // Capture data on enable rise
            if (data_en_rise) begin
                data_reg <= data_in;
            end
            
            // Set request when new data available
            if (data_en_rise) begin
                req_sync <= 1'b1;
            end else if (ack_sync_a) begin
                req_sync <= 1'b0;
            end
            
            // Synchronize ack from clk_b
            ack_sync_a <= ack_sync;
        end
    end
    
    // Clock domain B: Synchronize request
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b1 <= 1'b0;
            req_sync_b2 <= 1'b0;
            ack_sync <= 1'b0;
        end else begin
            // Two-stage synchronizer for request
            req_sync_b1 <= req_sync;
            req_sync_b2 <= req_sync_b1;
            
            // Generate acknowledge when request is stable
            ack_sync <= req_sync_b2;
            
            // Capture data when request is high
            if (req_sync_b2) begin
                data_buf <= data_reg;
            end
        end
    end
    
    // Clock domain B: Output data
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            // Update output when acknowledge is being sent
            if (req_sync_b2) begin
                dataout <= data_buf;
            end
        end
    end

endmodule