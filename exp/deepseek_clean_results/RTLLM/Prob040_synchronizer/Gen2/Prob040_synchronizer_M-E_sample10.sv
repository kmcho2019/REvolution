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
    reg req_a, ack_sync_a;
    wire ack_b_sync;

    // clk_b domain signals
    reg req_sync_b1, req_sync_b2;
    reg ack_b;
    reg [3:0] data_capture;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            // Capture data when enabled and not in middle of transfer
            if (data_en && !req_a && !ack_sync_a) begin
                data_reg <= data_in;
                req_a <= 1'b1;
            end
            // Clear request when acknowledge is received
            else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
        end
    end

    // Synchronize ack from clk_b to clk_a
    reg ack_sync_a1, ack_sync_a2;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync_a1 <= 1'b0;
            ack_sync_a2 <= 1'b0;
            ack_sync_a <= 1'b0;
        end else begin
            ack_sync_a1 <= ack_b;
            ack_sync_a2 <= ack_sync_a1;
            ack_sync_a <= ack_sync_a2;
        end
    end

    // clk_b domain logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b1 <= 1'b0;
            req_sync_b2 <= 1'b0;
            ack_b <= 1'b0;
            dataout <= 4'b0;
            data_capture <= 4'b0;
        end else begin
            // Synchronize request from clk_a
            req_sync_b1 <= req_a;
            req_sync_b2 <= req_sync_b1;

            // Capture data when synchronized request is detected
            if (req_sync_b2 && !ack_b) begin
                data_capture <= data_reg;
                ack_b <= 1'b1;
            end
            // Clear acknowledge when request goes away
            else if (!req_sync_b2 && ack_b) begin
                ack_b <= 1'b0;
            end

            // Update output when new data is captured
            if (req_sync_b2 && ack_b) begin
                dataout <= data_capture;
            end
        end
    end

endmodule