module synchronizer (
    input clk_a,
    input clk_b,
    input arstn, // Active-low reset for clk_a domain
    input brstn, // Active-low reset for clk_b domain
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg_a; // Data register in clk_a domain
reg req_a; // Request signal from clk_a to clk_b
reg ack_a; // Acknowledge signal from clk_b to clk_a
reg [3:0] data_reg_b; // Data register in clk_b domain
reg req_b; // Request signal in clk_b domain
reg ack_b; // Acknowledge signal in clk_b domain

// Stage 1: Capture data and generate request in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg_a <= 4'd0;
        req_a <= 1'd0;
    end else if (data_en) begin
        data_reg_a <= data_in;
        req_a <= 1'd1;
    end else begin
        req_a <= 1'd0;
    end
end

// Synchronize request signal from clk_a to clk_b
reg req_sync;
reg req_sync_d;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        req_sync <= 1'd0;
        req_sync_d <= 1'd0;
    end else begin
        req_sync <= req_a;
        req_sync_d <= req_sync;
    end
end

// Stage 2: Synchronize data in clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_reg_b <= 4'd0;
        ack_b <= 1'd0;
    end else if (req_sync_d) begin
        data_reg_b <= data_reg_a;
        ack_b <= 1'd1;
    end else begin
        ack_b <= 1'd0;
    end
end

// Generate acknowledge signal back to clk_a domain
reg ack_sync;
reg ack_sync_d;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        ack_sync <= 1'd0;
        ack_sync_d <= 1'd0;
    end else begin
        ack_sync <= ack_b;
        ack_sync_d <= ack_sync;
    end
end

// Output dataout when acknowledge is received
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (ack_b) begin
        dataout <= data_reg_b;
    end
end

endmodule