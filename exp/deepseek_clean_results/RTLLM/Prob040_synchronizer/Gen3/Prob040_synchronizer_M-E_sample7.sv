module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg req_a, ack_sync_a;
    reg data_en_prev;

    // clk_b domain registers
    reg [1:0] req_sync_b;
    reg ack_b;
    reg [1:0] ack_sync_b;

    // Edge detection for data_en
    wire data_en_posedge = data_en && !data_en_prev;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
            data_en_prev <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            
            // Capture data when enabled
            if (data_en) begin
                data_reg <= data_in;
            end
            
            // Set request on enable edge
            if (data_en_posedge) begin
                req_a <= 1'b1;
            end else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
            
            // Synchronize ack from clk_b
            ack_sync_a <= ack_sync_b[1];
        end
    end

    // clk_b domain logic - request synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b <= 2'b0;
            ack_b <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Synchronize request from clk_a
            req_sync_b <= {req_sync_b[0], req_a};
            
            // Generate acknowledge when request is stable
            if (req_sync_b[1] && !ack_b) begin
                ack_b <= 1'b1;
                dataout <= data_reg;
            end else if (!req_sync_b[1]) begin
                ack_b <= 1'b0;
            end
        end
    end

    // clk_b domain logic - acknowledge synchronization back
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_sync_b <= 2'b0;
        end else begin
            ack_sync_b <= {ack_sync_b[0], ack_b};
        end
    end

endmodule