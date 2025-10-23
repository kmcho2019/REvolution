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
    reg [3:0] data_hold;
    reg data_en_prev;
    wire data_en_rise;
    reg req_a;
    reg ack_sync_a;
    
    // Clock domain B signals
    reg [1:0] req_sync_b;
    reg ack_b;
    reg [1:0] ack_sync_b;
    reg data_valid;
    
    // Edge detection for data_en
    assign data_en_rise = data_en & ~data_en_prev;
    
    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_hold <= 4'b0;
            data_en_prev <= 1'b0;
            req_a <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            
            // Capture data on enable rise
            if (data_en_rise) begin
                data_hold <= data_in;
                req_a <= ~req_a;  // Toggle request
            end
            
            // Synchronize ack from domain B
            ack_sync_a <= ack_sync_b[1];
        end
    end
    
    // Clock domain B synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b <= 2'b0;
            ack_b <= 1'b0;
            ack_sync_b <= 2'b0;
            dataout <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            // Synchronize request from domain A (gray coding)
            req_sync_b <= {req_sync_b[0], req_a};
            
            // Detect request change
            if (req_sync_b[1] ^ req_sync_b[0]) begin
                dataout <= data_hold;
                data_valid <= 1'b1;
                ack_b <= req_sync_b[1];  // Echo back the request
            end else begin
                data_valid <= 1'b0;
            end
            
            // Synchronize ack to domain A
            ack_sync_b <= {ack_sync_b[0], ack_b};
        end
    end

endmodule