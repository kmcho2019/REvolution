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
    reg req_a;
    wire ack_sync;
    
    // clk_b domain signals
    reg req_sync1, req_sync2;
    reg ack_b;
    reg [3:0] data_buf;

    // Data capture and request generation in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            data_reg <= data_in;
            // Generate request pulse when data_en rises
            req_a <= data_en & ~(req_a & ~ack_sync);
        end
    end

    // Two-stage synchronizer for request (clk_a -> clk_b)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {req_sync1, req_sync2} <= 2'b00;
        end else begin
            req_sync1 <= req_a;
            req_sync2 <= req_sync1;
        end
    end

    // Data capture and acknowledge generation in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
            data_buf <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // Capture data when request is detected
            if (req_sync2 && !ack_b) begin
                data_buf <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync2) begin
                ack_b <= 1'b0;
            end
            
            // Update output only after successful handshake
            if (ack_b) begin
                dataout <= data_buf;
            end
        end
    end

    // Two-stage synchronizer for acknowledge (clk_b -> clk_a)
    reg ack_sync1, ack_sync2;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            {ack_sync1, ack_sync2} <= 2'b00;
        end else begin
            ack_sync1 <= ack_b;
            ack_sync2 <= ack_sync1;
        end
    end
    
    assign ack_sync = ack_sync2;

endmodule