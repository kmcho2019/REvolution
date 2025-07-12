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
    reg [3:0] data_reg_a;
    reg req_a, req_a_sync;
    reg ack_b_sync;

    // Clock domain B signals
    reg [3:0] data_reg_b;
    reg ack_b;
    reg req_a_sync1, req_a_sync2;
    reg ack_b_sync1, ack_b_sync2;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            req_a <= 1'b0;
            ack_b_sync <= 1'b0;
        end else begin
            // Capture data when enabled and not busy
            if (data_en && !req_a && !ack_b_sync) begin
                data_reg_a <= data_in;
                req_a <= 1'b1;
            end
            // Clear request when acknowledge is received
            else if (req_a && ack_b_sync) begin
                req_a <= 1'b0;
            end
            
            // Synchronize ack from domain B
            ack_b_sync <= ack_b_sync2;
        end
    end

    // Clock domain B logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            dataout <= 4'b0;
            ack_b <= 1'b0;
            req_a_sync1 <= 1'b0;
            req_a_sync2 <= 1'b0;
            ack_b_sync1 <= 1'b0;
            ack_b_sync2 <= 1'b0;
        end else begin
            // Synchronize request from domain A (2-stage)
            req_a_sync1 <= req_a;
            req_a_sync2 <= req_a_sync1;
            
            // Generate acknowledge after 3 cycles
            if (req_a_sync2 && !ack_b) begin
                data_reg_b <= data_reg_a;
                ack_b <= 1'b1;
            end else if (!req_a_sync2 && ack_b) begin
                ack_b <= 1'b0;
            end
            
            // Output registered data when valid
            if (ack_b) begin
                dataout <= data_reg_b;
            end
            
            // Synchronize ack for domain A (2-stage)
            ack_b_sync1 <= ack_b;
            ack_b_sync2 <= ack_b_sync1;
        end
    end

endmodule