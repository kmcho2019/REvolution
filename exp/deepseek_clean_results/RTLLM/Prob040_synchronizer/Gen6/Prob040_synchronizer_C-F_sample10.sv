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
    reg request_sync1, request_sync2;
    reg acknowledge;

    // clk_a domain logic - data capture
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            request <= 1'b0;
        end else begin
            // Capture data and set request when enabled
            if (data_en) begin
                data_reg <= data_in;
                request <= 1'b1;
            end
            // Clear request when acknowledged (safe due to minimum 3-cycle enable)
            else if (acknowledge) begin
                request <= 1'b0;
            end
        end
    end

    // clk_b domain - request synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {request_sync2, request_sync1} <= 2'b00;
            acknowledge <= 1'b0;
        end else begin
            // Two-stage synchronizer for request
            {request_sync2, request_sync1} <= {request_sync1, request};
            
            // Generate acknowledge when request is stable
            acknowledge <= request_sync2;
        end
    end

    // clk_b domain - data output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (request_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule