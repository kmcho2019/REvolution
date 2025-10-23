module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg data_en_prev;
    wire data_en_rise;
    reg req_a;
    reg ack_sync1_a, ack_sync2_a;

    // Clock domain B registers
    reg req_sync1_b, req_sync2_b;
    reg ack_b;
    reg [3:0] data_capture;

    // Edge detection and request generation (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_prev <= 1'b0;
            req_a <= 1'b0;
            ack_sync1_a <= 1'b0;
            ack_sync2_a <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            // Clear request when acknowledge is received
            req_a <= data_en_rise ? 1'b1 : (ack_sync2_a ? 1'b0 : req_a);
            // Synchronize ack from clk_b
            {ack_sync2_a, ack_sync1_a} <= {ack_sync1_a, ack_b};
        end
    end

    assign data_en_rise = data_en && !data_en_prev;

    // Data capture (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en_rise) begin
            data_reg <= data_in;
        end
    end

    // Request synchronization (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {req_sync2_b, req_sync1_b} <= 2'b00;
            ack_b <= 1'b0;
            data_capture <= 4'b0;
        end else begin
            // Synchronize request from clk_a
            {req_sync2_b, req_sync1_b} <= {req_sync1_b, req_a};
            
            // Generate acknowledge when request is stable
            ack_b <= req_sync2_b;
            
            // Capture data when request is first detected
            if (req_sync2_b && !ack_b) begin
                data_capture <= data_reg;
            end
        end
    end

    // Output assignment (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (req_sync2_b && ack_b) begin
            dataout <= data_capture;
        end
    end

endmodule