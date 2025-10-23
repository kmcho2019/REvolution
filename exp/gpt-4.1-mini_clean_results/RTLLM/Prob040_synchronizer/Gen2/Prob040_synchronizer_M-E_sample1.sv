module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Holding register for data latched in clk_a domain when data_en is high
reg [3:0] data_hold;
reg       data_en_d;  // data_en delayed in clk_a domain for edge detection (optional)

// Synchronizer registers for data_en crossing into clk_b domain (2-stage)
reg en_sync_0;
reg en_sync_1;

// Generate pulse in clk_b domain when synchronized enable rises
wire en_pulse = en_sync_1 & ~en_sync_0;

// Latch data_hold in clk_a domain when data_en is high
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_hold <= 4'd0;
        data_en_d <= 1'b0;
    end else begin
        data_en_d <= data_en;
        if (data_en) begin
            data_hold <= data_in;
        end
    end
end

// Synchronize data_en into clk_b domain - two flip-flops to avoid metastability
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync_0 <= 1'b0;
        en_sync_1 <= 1'b0;
    end else begin
        en_sync_0 <= data_en_d;  // synchronized version of data_en delayed 1 clk_a cycle
        en_sync_1 <= en_sync_0;
    end
end

// Transfer data_hold from clk_a domain to clk_b domain on data enable pulse
// Using a register to hold latched data synchronized to clk_b domain
reg [3:0] data_b_reg;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_b_reg <= 4'd0;
        dataout <= 4'd0;
    end else begin
        if (en_pulse) begin
            data_b_reg <= data_hold;   // capture new data when enable pulse rises
        end
        // MUX-based output selection: output updated only on enable pulse
        dataout <= en_sync_1 ? data_b_reg : dataout;
    end
end

endmodule