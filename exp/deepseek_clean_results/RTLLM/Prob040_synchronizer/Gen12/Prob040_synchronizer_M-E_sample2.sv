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
    reg req_a, req_a_prev;
    wire en_rise;
    
    // clk_b domain signals
    reg req_b_sync1, req_b_sync2;
    reg ack_b, ack_b_sync1, ack_b_sync2;
    reg [3:0] data_buf;

    // Edge detection and data capture in clk_a domain
    assign en_rise = data_en & ~req_a_prev;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
            req_a_prev <= 1'b0;
        end else begin
            req_a_prev <= data_en;
            if (en_rise) begin
                data_reg <= data_in;
                req_a <= 1'b1;
            end else if (ack_b_sync2) begin
                req_a <= 1'b0;
            end
        end
    end

    // Synchronize req to clk_b domain (2-stage)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_b_sync1 <= 1'b0;
            req_b_sync2 <= 1'b0;
            ack_b <= 1'b0;
        end else begin
            req_b_sync1 <= req_a;
            req_b_sync2 <= req_b_sync1;
            
            // Generate acknowledge when request is stable
            ack_b <= req_b_sync2;
        end
    end

    // Synchronize ack back to clk_a domain (2-stage)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_b_sync1 <= 1'b0;
            ack_b_sync2 <= 1'b0;
        end else begin
            ack_b_sync1 <= ack_b;
            ack_b_sync2 <= ack_b_sync1;
        end
    end

    // Data capture and output in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_buf <= 4'b0;
            dataout <= 4'b0;
        end else begin
            if (req_b_sync2) begin
                data_buf <= data_reg;
            end
            // Only update output when handshake is complete
            if (ack_b) begin
                dataout <= data_buf;
            end
        end
    end

endmodule