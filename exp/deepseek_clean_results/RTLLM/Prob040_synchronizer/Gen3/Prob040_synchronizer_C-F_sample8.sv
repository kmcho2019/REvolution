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

    // clk_b domain signals
    reg request_sync_b1, request_sync_b2;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            request <= 1'b0;
        end else begin
            // Capture data when enabled
            if (data_en) begin
                data_reg <= data_in;
                request <= 1'b1;
            end
            // Clear request after minimum hold time (implied by spec)
            else if (request && !data_en) begin
                request <= 1'b0;
            end
        end
    end

    // Synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            request_sync_b1 <= 1'b0;
            request_sync_b2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Two-stage synchronizer for request
            request_sync_b1 <= request;
            request_sync_b2 <= request_sync_b1;
            
            // Data output when synchronized enable is active
            if (request_sync_b2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule