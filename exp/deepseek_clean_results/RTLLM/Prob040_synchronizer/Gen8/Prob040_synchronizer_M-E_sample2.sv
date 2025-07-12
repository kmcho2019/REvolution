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
    reg [3:0] data_reg_a;
    reg req_a, ack_sync_a;
    reg [1:0] en_gray_a;

    // Clock domain B registers
    reg [3:0] data_reg_b;
    reg req_sync1_b, req_sync2_b, req_sync3_b;
    reg ack_b;
    reg [1:0] en_gray_b;

    // Data valid window detector
    reg [1:0] valid_window;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            req_a <= 1'b0;
            en_gray_a <= 2'b00;
        end else begin
            // Convert enable to gray code
            en_gray_a <= {data_en, en_gray_a[1] ^ data_en};
            
            // Capture data when enabled
            if (data_en) begin
                data_reg_a <= data_in;
            end
            
            // Handshake request generation
            if (data_en && !req_a && !ack_sync_a) begin
                req_a <= 1'b1;
            end else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
        end
    end

    // Synchronize ack to clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync_a <= 1'b0;
        end else begin
            ack_sync_a <= ack_b;
        end
    end

    // Clock domain B logic - control path
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {req_sync1_b, req_sync2_b, req_sync3_b} <= 3'b000;
            ack_b <= 1'b0;
            en_gray_b <= 2'b00;
        end else begin
            // Triple-stage synchronizer for request
            {req_sync3_b, req_sync2_b, req_sync1_b} <= {req_sync2_b, req_sync1_b, req_a};
            
            // Convert gray code back to binary
            en_gray_b <= {req_sync3_b, en_gray_b[1] ^ req_sync3_b};
            
            // Generate acknowledge
            if (req_sync3_b && !ack_b) begin
                ack_b <= 1'b1;
            end else if (!req_sync3_b) begin
                ack_b <= 1'b0;
            end
        end
    end

    // Clock domain B logic - data path
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            valid_window <= 2'b00;
            dataout <= 4'b0;
        end else begin
            // Data valid window detection
            valid_window <= {valid_window[0], en_gray_b[0]};
            
            // Capture data during valid window
            if (valid_window == 2'b01) begin
                data_reg_b <= data_reg_a;
            end
            
            // Update output only when data is stable
            if (valid_window == 2'b11) begin
                dataout <= data_reg_b;
            end
        end
    end

endmodule