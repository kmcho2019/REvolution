module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout,
    output wire data_valid
);

    // Clock domain A signals
    reg [3:0] data_reg;
    reg request_a;
    reg ack_sync_a;
    wire ack_b_sync;

    // Clock domain B signals
    reg request_sync_b1, request_sync_b2;
    reg ack_b;
    reg [3:0] data_sync_reg;
    reg data_valid_reg;

    // Assign output
    assign data_valid = data_valid_reg;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            request_a <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            // Capture data when enabled and no pending request
            if (data_en && !request_a && !ack_sync_a) begin
                data_reg <= data_in;
                request_a <= 1'b1;
            end
            
            // Clear request when acknowledge is received
            if (ack_sync_a) begin
                request_a <= 1'b0;
            end
            
            // Synchronize ack from domain B
            ack_sync_a <= ack_b_sync;
        end
    end

    // First stage of request synchronization (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            request_sync_b1 <= 1'b0;
            request_sync_b2 <= 1'b0;
        end else begin
            request_sync_b1 <= request_a;
            request_sync_b2 <= request_sync_b1;
        end
    end

    // Generate acknowledge when request is stable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
            data_sync_reg <= 4'b0;
            data_valid_reg <= 1'b0;
        end else begin
            // Capture data when request is stable
            if (request_sync_b2 && !ack_b) begin
                data_sync_reg <= data_reg;
                data_valid_reg <= 1'b1;
                ack_b <= 1'b1;
            end else if (!request_sync_b2) begin
                ack_b <= 1'b0;
                data_valid_reg <= 1'b0;
            end
            
            // Output data
            dataout <= data_sync_reg;
        end
    end

    // Synchronize acknowledge back to clk_a domain
    reg ack_sync_a1, ack_sync_a2;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync_a1 <= 1'b0;
            ack_sync_a2 <= 1'b0;
        end else begin
            ack_sync_a1 <= ack_b;
            ack_sync_a2 <= ack_sync_a1;
        end
    end
    assign ack_b_sync = ack_sync_a2;

endmodule