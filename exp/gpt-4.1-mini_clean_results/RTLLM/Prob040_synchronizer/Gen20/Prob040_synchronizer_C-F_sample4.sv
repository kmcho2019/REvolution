module en_sync(
    input        clk_b,
    input        brstn,
    input        en_in,
    output reg   en_sync_out
);
    reg en_ff1;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_ff1 <= 1'b0;
            en_sync_out <= 1'b0;
        end else begin
            en_ff1 <= en_in;
            en_sync_out <= en_ff1;
        end
    end
endmodule

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

// 2) Synchronize data_en_reg_a into clk_b domain using en_sync module (2-stage synchronizer)
wire en_sync_1, en_sync_2;

en_sync en_sync_inst (
    .clk_b(clk_b),
    .brstn(brstn),
    .en_in(data_en_reg_a),
    .en_sync_out(en_sync_1)
);

en_sync en_sync_inst2 (
    .clk_b(clk_b),
    .brstn(brstn),
    .en_in(en_sync_1),
    .en_sync_out(en_sync_2)
);

// 3) Generate load pulse on clk_b domain on rising edge of synchronized enable (between en_sync_1 and en_sync_2)
wire load_pulse = en_sync_1 & ~en_sync_2;

// 4) Register to hold stable data from clk_a domain, updated on clk_b domain at load pulse
// Sampling data_reg_a asynchronously is safe because data_in is stable when data_en_reg_a is high
reg [3:0] data_reg_b;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_b <= 4'b0;
    end else if (load_pulse) begin
        data_reg_b <= data_reg_a;
    end
end

// 5) Output register captures data_reg_b only when synchronized enable is asserted (en_sync_2)
// This ensures dataout updates only during enable window and holds previous value otherwise
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_sync_2) begin
        dataout <= data_reg_b;
    end
    // else hold previous dataout
end

endmodule