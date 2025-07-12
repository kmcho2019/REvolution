module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain
    reg [3:0] frozen_data;
    reg en_frozen;
    
    // Clock B domain
    reg [1:0] en_sync;
    reg [3:0] sync_data;
    reg data_valid;

    // Freeze data when enable is asserted (Clock A domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            frozen_data <= 4'b0;
            en_frozen <= 1'b0;
        end else begin
            if (data_en) begin
                frozen_data <= data_in;
                en_frozen <= 1'b1;
            end else begin
                en_frozen <= 1'b0;
            end
        end
    end

    // Two-stage enable synchronization (Clock B domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
            data_valid <= 1'b0;
        end else begin
            en_sync <= {en_sync[0], en_frozen};
            data_valid <= en_sync[1];
        end
    end

    // Data capture and output (Clock B domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_data <= 4'b0;
            dataout <= 4'b0;
        end else begin
            if (en_sync[0] && !en_sync[1]) begin  // Rising edge detection
                sync_data <= frozen_data;
            end
            if (data_valid) begin
                dataout <= sync_data;
            end
        end
    end

endmodule