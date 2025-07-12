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
    wire req_pulse = data_en && !req_a;  // Edge detection
    
    // clk_b domain signals
    reg [1:0] req_sync_b;
    reg ack_b;
    reg [3:0] data_capture;
    
    // Request generation in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 1'b0;
            data_reg <= 4'b0;
        end else begin
            if (req_pulse) begin
                req_a <= 1'b1;
                data_reg <= data_in;
            end else if (ack_sync_a) begin
                req_a <= 1'b0;
            end
        end
    end
    
    // Synchronize ack back to clk_a domain
    reg [1:0] ack_sync;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync <= 2'b0;
            ack_sync_a <= 1'b0;
        end else begin
            ack_sync <= {ack_sync[0], ack_b};
            ack_sync_a <= ack_sync[1];
        end
    end
    
    // Synchronize req to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_b <= 2'b0;
        end else begin
            req_sync_b <= {req_sync_b[0], req_a};
        end
    end
    
    // Data capture and ack generation in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 1'b0;
            data_capture <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // Capture data when synchronized request arrives
            if (req_sync_b[1] && !ack_b) begin
                data_capture <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync_b[1]) begin
                ack_b <= 1'b0;
            end
            
            // Update output only with valid captured data
            if (ack_b) begin
                dataout <= data_capture;
            end
        end
    end

endmodule