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
    reg req_a, ack_sync_a;
    wire ack_b_sync;

    // Clock domain B signals
    reg req_sync_b, req_sync_b_d;
    reg ack_b;
    reg [3:0] data_sync_reg;
    reg data_valid;

    // Gray code conversion for handshake signals
    wire req_gray = req_a;
    wire ack_gray = ack_b;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            // Capture data when enabled and not waiting for ack
            if (data_en && !req_a && !ack_sync_a) begin
                data_reg <= data_in;
                req_a <= 1'b1;
            end
            // Clear request when ack received
            else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
            
            // Synchronize ack from clk_b
            ack_sync_a <= ack_gray;
        end
    end

    // First stage of req synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b <= 1'b0;
            req_sync_b_d <= 1'b0;
        end else begin
            req_sync_b <= req_gray;
            req_sync_b_d <= req_sync_b;
        end
    end

    // Handshake control in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
            data_sync_reg <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            // Generate ack when request is stable
            if (req_sync_b && !req_sync_b_d && !ack_b) begin
                ack_b <= 1'b1;
                data_sync_reg <= data_reg;
                data_valid <= 1'b1;
            end
            // Clear ack when request drops
            else if (!req_sync_b) begin
                ack_b <= 1'b0;
            end
            
            // Clear data valid after one cycle
            if (data_valid) begin
                data_valid <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (data_valid) begin
            dataout <= data_sync_reg;
        end
    end

endmodule