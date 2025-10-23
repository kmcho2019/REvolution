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
    reg [3:0] data_reg_a;
    reg req_a, ack_sync_a;
    reg data_en_prev;
    
    // Clock domain B signals
    reg [2:0] req_sync_b;  // 3-stage synchronizer
    reg ack_b;
    reg [3:0] data_reg_b;
    reg [3:0] data_snapshot;
    reg data_valid;
    
    // Generate request pulse on rising edge of data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_prev <= 1'b0;
            req_a <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            // Generate single-cycle request pulse
            req_a <= data_en & ~data_en_prev;
        end
    end
    
    // Capture data when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
        end else if (data_en) begin
            data_reg_a <= data_in;
        end
    end
    
    // Synchronize request to clk_b domain (3 stages)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b <= 3'b0;
        end else begin
            req_sync_b <= {req_sync_b[1:0], req_a};
        end
    end
    
    // Generate acknowledge when request is stable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
        end else if (req_sync_b[2] & ~req_sync_b[1]) begin
            ack_b <= 1'b1;
        end else begin
            ack_b <= 1'b0;
        end
    end
    
    // Synchronize acknowledge back to clk_a domain
    reg [1:0] ack_sync;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync <= 2'b0;
            ack_sync_a <= 1'b0;
        end else begin
            ack_sync <= {ack_sync[0], ack_b};
            ack_sync_a <= ack_sync[1];
        end
    end
    
    // Data capture and validation in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_snapshot <= 4'b0;
            data_valid <= 1'b0;
            data_reg_b <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // Take snapshot when request first arrives
            if (req_sync_b[1] & ~req_sync_b[0]) begin
                data_snapshot <= data_reg_a;
            end
            
            // Validate data when request is stable
            if (req_sync_b[2]) begin
                data_valid <= (data_snapshot == data_reg_a);
            end else begin
                data_valid <= 1'b0;
            end
            
            // Update output register when handshake is complete
            if (req_sync_b[2] & data_valid) begin
                data_reg_b <= data_snapshot;
                dataout <= data_snapshot;
            end
        end
    end

endmodule