module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Dual-Port RAM
reg [3:0] ram [0:1];
integer ram_addr;

// Clock Domain Crossing (CDC) Module
reg data_en_sync;
reg data_en_sync_ff;

// Metastability Resolver
reg [1:0] meta_resolver;

// MUX-Based Synchronizer
reg [3:0] dataout_reg;

// Write data to RAM in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        ram[0] <= 4'd0;
        ram[1] <= 4'd0;
    end else if (data_en) begin
        ram[0] <= data_in;
        ram[1] <= ram[0];
    end
end

// CDC Module to synchronize data_en
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_en_sync <= 1'b0;
        data_en_sync_ff <= 1'b0;
    end else begin
        data_en_sync <= data_en;
        data_en_sync_ff <= data_en_sync;
    end
end

// Metastability Resolver
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        meta_resolver <= 2'd0;
    end else begin
        meta_resolver <= {meta_resolver[0], data_en_sync_ff};
    end
end

// MUX-Based Synchronizer
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout_reg <= 4'd0;
    end else if (meta_resolver[1]) begin
        dataout_reg <= ram[1];
    end
end

// Output Assignment
assign dataout = dataout_reg;

endmodule