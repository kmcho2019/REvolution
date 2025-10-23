module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Data capture with stability check
    reg [3:0] data_reg;
    reg [3:0] prev_data;
    reg en_data_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            prev_data <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            prev_data <= data_in;
            if (data_en) begin
                // Only update if data is stable (matches previous cycle)
                if (data_in == prev_data) begin
                    data_reg <= data_in;
                    en_data_reg <= 1'b1;
                end
            end else begin
                en_data_reg <= 1'b0;
            end
        end
    end

    // Clock B domain - Two-stage synchronizer
    reg en_sync1, en_sync2;
    reg [3:0] data_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            data_sync <= 4'b0;
        end else begin
            // Synchronize enable signal
            en_sync1 <= en_data_reg;
            en_sync2 <= en_sync1;
            
            // Capture data when first sync stage is high
            if (en_sync1) begin
                data_sync <= data_reg;
            end
        end
    end

    // Output register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_sync;
        end
    end

endmodule