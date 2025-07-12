module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // CLK_A Domain
    reg [3:0] data_reg;
    reg req_a, ack_sync_a;
    reg [1:0] ack_sync_stages_a;
    
    // Capture data only when enabled and not waiting for ack
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else if (data_en && !req_a) begin
            data_reg <= data_in;
            req_a <= 1'b1;
        end else if (ack_sync_a) begin
            req_a <= 1'b0;
        end
    end

    // Synchronize ack from clk_b (3 stages)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync_stages_a <= 2'b00;
            ack_sync_a <= 1'b0;
        end else begin
            {ack_sync_a, ack_sync_stages_a} <= {ack_sync_stages_a, ack_b};
        end
    end

    // CLK_B Domain
    reg [3:0] data_sync_reg;
    reg ack_b, req_sync_b;
    reg [2:0] req_sync_stages_b;
    reg [1:0] valid_counter;
    
    // Synchronize req from clk_a (3 stages)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync_stages_b <= 3'b000;
            req_sync_b <= 1'b0;
        end else begin
            {req_sync_b, req_sync_stages_b} <= {req_sync_stages_b, req_a};
        end
    end

    // Data capture and valid window tracking
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync_reg <= 4'b0;
            ack_b <= 1'b0;
            valid_counter <= 2'b00;
            dataout <= 4'b0;
        end else begin
            // Capture data when request is newly detected
            if (req_sync_b && !ack_b) begin
                data_sync_reg <= data_reg;
                ack_b <= 1'b1;
                valid_counter <= 2'b11; // Initialize 3-cycle counter
            end
            // Clear ack when request drops
            else if (!req_sync_b && ack_b) begin
                ack_b <= 1'b0;
            end
            
            // Valid window control
            if (valid_counter != 0) begin
                valid_counter <= valid_counter - 1;
                if (valid_counter == 2'b01) begin // Update output on last valid cycle
                    dataout <= data_sync_reg;
                end
            end
        end
    end

endmodule