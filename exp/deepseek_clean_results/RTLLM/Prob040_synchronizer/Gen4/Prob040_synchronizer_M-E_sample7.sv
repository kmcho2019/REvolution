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
    reg req;
    reg ack_sync1, ack_sync2;

    // Clock domain B signals
    reg req_sync1, req_sync2;
    reg ack;

    // Edge detection and request generation in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_prev <= 1'b0;
            req <= 1'b0;
            data_reg <= 4'b0;
            ack_sync1 <= 1'b0;
            ack_sync2 <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            // Capture data when enable rises
            if (data_en_rise) begin
                data_reg <= data_in;
                req <= 1'b1;
            end
            // Clear request when acknowledge received
            else if (ack_sync2) begin
                req <= 1'b0;
            end
            // Synchronize ack from clk_b
            ack_sync1 <= ack;
            ack_sync2 <= ack_sync1;
        end
    end

    assign data_en_rise = data_en && !data_en_prev;

    // Request synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
            ack <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Two-stage synchronizer for request
            req_sync1 <= req;
            req_sync2 <= req_sync1;
            
            // Generate acknowledge when synchronized request detected
            ack <= req_sync2;
            
            // Capture data when synchronized request is high
            if (req_sync2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule