module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Edge detection and data freeze
    reg [3:0] frozen_data;
    reg data_en_prev;
    wire data_en_rise = data_en & ~data_en_prev;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            frozen_data <= 4'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            if (data_en_rise) begin
                frozen_data <= data_in;  // Freeze data on enable edge
            end
        end
    end

    // Toggle generation for synchronization
    reg toggle_a;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            toggle_a <= 1'b0;
        end else if (data_en_rise) begin
            toggle_a <= ~toggle_a;  // Toggle on new data
        end
    end

    // Clock B domain - Toggle synchronization
    reg [2:0] sync_chain;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_chain <= 3'b0;
        end else begin
            sync_chain <= {sync_chain[1:0], toggle_a};
        end
    end
    
    // Edge detection in clk_b domain
    wire sync_edge = sync_chain[2] ^ sync_chain[1];
    
    // Data validity window (ensures 3-cycle stability)
    reg [1:0] valid_window;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            valid_window <= 2'b0;
        end else begin
            valid_window <= {valid_window[0], sync_edge};
        end
    end
    
    // Data capture when valid
    wire capture_en = valid_window == 2'b01;
    
    // Output register with enable gating
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (capture_en) begin
            dataout <= frozen_data;
        end
    end

endmodule