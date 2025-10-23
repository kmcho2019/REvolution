module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,      // async active low reset clk_a domain
    input             brstn,      // async active low reset clk_b domain
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// 1) Capture data_in and data_en in clk_a domain (async reset)
reg [3:0] data_reg_a;
reg       data_en_reg_a;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a    <= 4'b0;
        data_en_reg_a <= 1'b0;
    end else begin
        data_reg_a    <= data_in;
        data_en_reg_a <= data_en;
    end
end

// 2) Synchronize data_en_reg_a into clk_b domain using 2-stage synchronizer
reg data_en_sync_0, data_en_sync_1;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_en_sync_0 <= 1'b0;
        data_en_sync_1 <= 1'b0;
    end else begin
        data_en_sync_0 <= data_en_reg_a;
        data_en_sync_1 <= data_en_sync_0;
    end
end

// 3) Generate load pulse on clk_b domain on rising edge of synchronized enable
wire load_pulse = data_en_sync_0 & (~data_en_sync_1);

// 4) Register to hold stable data from clk_a domain, updated on clk_b domain
// Use data_reg_a value from clk_a domain captured output (safe to sample in clk_b domain)
// Assuming data_reg_a changes slowly and is stable when data_en_reg_a=1
reg [3:0] data_reg_b;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_b <= 4'b0;
    end else if (load_pulse) begin
        data_reg_b <= data_reg_a;
    end
end

// 5) Output register captures data_reg_b when enable is asserted
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (data_en_sync_1) begin
        dataout <= data_reg_b;
    end
    // else hold previous value
end

endmodule