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
    reg req_pending;

    // clk_b domain signals
    reg req_sync_b, req_sync_b_meta;
    reg ack_b;
    reg [3:0] data_buf;

    // Synchronize ack from clk_b to clk_a (dual flop)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            {ack_sync_a, req_pending} <= 2'b0;
        end else begin
            ack_sync_a <= ack_b;
            if (ack_sync_a && req_pending) begin
                req_pending <= 1'b0;
            end
        end
    end

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            if (data_en && !req_pending) begin
                data_reg <= data_in;
                req_a <= 1'b1;
                req_pending <= 1'b1;
            end else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
        end
    end

    // Synchronize req from clk_a to clk_b (dual flop)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {req_sync_b, req_sync_b_meta} <= 2'b0;
        end else begin
            req_sync_b_meta <= req_a;
            req_sync_b <= req_sync_b_meta;
        end
    end

    // clk_b domain logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
            data_buf <= 4'b0;
            ack_b <= 1'b0;
        end else begin
            // Capture data when new request arrives
            if (req_sync_b && !ack_b) begin
                data_buf <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync_b && ack_b) begin
                ack_b <= 1'b0;
            end

            // Update output only when transfer is complete
            if (ack_b) begin
                dataout <= data_buf;
            end
        end
    end

endmodule