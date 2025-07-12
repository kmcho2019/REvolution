module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Data capture with enable qualification
    reg [3:0] data_reg;
    reg data_valid;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
                data_valid <= 1'b1;
            end else if (data_valid) begin
                // Clear valid after one cycle to prevent multiple captures
                data_valid <= 1'b0;
            end
        end
    end

    // Clock B domain - Enable synchronization
    reg en_sync1, en_sync2;
    reg [3:0] sync_data;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            sync_data <= 4'b0;
        end else begin
            // Two-stage synchronizer for metastability protection
            en_sync1 <= data_valid;
            en_sync2 <= en_sync1;
            
            // Capture data when synchronized enable is active
            if (en_sync1) begin
                sync_data <= data_reg;
            end
        end
    end

    // Output register with change detection
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2 && (dataout != sync_data)) begin
            dataout <= sync_data;
        end
    end

endmodule