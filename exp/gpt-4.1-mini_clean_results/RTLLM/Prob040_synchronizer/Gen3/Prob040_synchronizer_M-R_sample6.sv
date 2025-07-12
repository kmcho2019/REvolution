module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Capture data_in and data_en on clk_a domain asynchronously reset by arstn (active low)
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Synchronize brstn (active low) into clk_b domain synchronously
reg brstn_sync1, brstn_sync2;

always @(posedge clk_b) begin
    brstn_sync1 <= brstn;
    brstn_sync2 <= brstn_sync1;
end

wire brstn_sync = brstn_sync2;

// Two-stage enable synchronization registers in clk_b domain
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_b or negedge brstn_sync) begin
    if (!brstn_sync) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Mux select signal based on synchronized enable
wire enable_mux = en_clap_two;

// Combinational logic to choose data source
wire [3:0] next_dataout = enable_mux ? data_reg : dataout;

// Output register with synchronous reset to brstn_sync
always @(posedge clk_b or negedge brstn_sync) begin
    if (!brstn_sync)
        dataout <= 4'b0;
    else
        dataout <= next_dataout;
end

endmodule