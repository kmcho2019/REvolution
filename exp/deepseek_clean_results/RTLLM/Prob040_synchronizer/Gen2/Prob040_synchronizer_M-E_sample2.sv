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
    reg request;
    reg ack_sync_a;

    // clk_b domain signals
    reg request_sync_b1, request_sync_b2;
    reg acknowledge;
    reg ack_sync_b1, ack_sync_b2;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            request <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            // Capture data when enabled
            if (data_en) begin
                data_reg <= data_in;
                request <= 1'b1;
            end
            // Clear request when acknowledged
            else if (ack_sync_a) begin
                request <= 1'b0;
            end
            
            // Synchronize acknowledge from clk_b
            ack_sync_a <= ack_sync_b2;
        end
    end

    // First stage of request synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            request_sync_b1 <= 1'b0;
            request_sync_b2 <= 1'b0;
            acknowledge <= 1'b0;
        end else begin
            // Two-stage synchronizer for request
            request_sync_b1 <= request;
            request_sync_b2 <= request_sync_b1;
            
            // Generate acknowledge when request is stable
            acknowledge <= request_sync_b2;
        end
    end

    // Synchronize acknowledge back to clk_a domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_sync_b1 <= 1'b0;
            ack_sync_b2 <= 1'b0;
        end else begin
            ack_sync_b1 <= acknowledge;
            ack_sync_b2 <= ack_sync_b1;
        end
    end

    // Data output in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (request_sync_b2) begin
            dataout <= data_reg;
        end
    end

endmodule