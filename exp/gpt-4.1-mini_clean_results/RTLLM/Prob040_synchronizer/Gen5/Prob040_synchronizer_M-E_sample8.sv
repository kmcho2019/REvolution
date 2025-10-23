module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Registers in clk_a domain to capture data_in and data_en
reg [3:0] data_reg;
reg       en_data_reg;

// clk_b domain registers for enable synchronization (2-stage)
reg en_clap_one, en_clap_two;

// Double-register stage for data crossing clk domains
reg [3:0] data_stage_1, data_stage_2;

// Internal signal to detect enable active condition in clk_b domain
wire en_active = en_clap_two;

// Capture data_in and data_en on clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Synchronize en_data_reg into clk_b domain through 2 D-flip flops
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Double-register data_reg into clk_b domain registers to avoid metastability
// Only update when en_active is high to latch stable data across domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_stage_1 <= 4'b0;
        data_stage_2 <= 4'b0;
    end else begin
        if (en_active)
            data_stage_1 <= data_reg;
        data_stage_2 <= data_stage_1;
    end
end

// Output register update: when enable active, update dataout with synchronized data_stage_2, else hold previous value
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else if (en_active)
        dataout <= data_stage_2;
    else
        dataout <= dataout;
end

endmodule