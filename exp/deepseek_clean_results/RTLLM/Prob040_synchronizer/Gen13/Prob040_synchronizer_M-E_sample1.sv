module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Request generation in clk_a domain
    reg req_a;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 1'b0;
        end else begin
            req_a <= data_en;
        end
    end

    // Data register in clk_a domain
    reg [3:0] data_a;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_a <= 4'b0;
        end else if (data_en) begin
            data_a <= data_in;
        end
    end

    // Synchronize request to clk_b domain (2-stage)
    reg req_sync1, req_sync2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
        end else begin
            req_sync1 <= req_a;
            req_sync2 <= req_sync1;
        end
    end

    // Generate acknowledge in clk_b domain
    reg ack_b;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
        end else begin
            ack_b <= req_sync2;
        end
    end

    // Synchronize acknowledge back to clk_a domain (2-stage)
    reg ack_sync1, ack_sync2;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync1 <= 1'b0;
            ack_sync2 <= 1'b0;
        end else begin
            ack_sync1 <= ack_b;
            ack_sync2 <= ack_sync1;
        end
    end

    // Data transfer and output in clk_b domain
    reg [3:0] data_b;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_b <= 4'b0;
            dataout <= 4'b0;
        end else if (req_sync2) begin
            data_b <= data_a;  // Safe transfer when handshake complete
            dataout <= data_b;  // One cycle delay for better timing
        end
    end

    // Clear request when handshake complete (in clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 1'b0;
        end else if (ack_sync2) begin
            req_a <= 1'b0;
        end
    end

endmodule