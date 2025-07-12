module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    (* clock_gating *)
    reg [3:0] data_reg /* synthesis preserve */;
    reg en_data_reg;

    // Clock domain B synchronization registers
    (* low_power *)
    reg en_sync1 /* synthesis preserve */;
    (* low_power *)
    reg en_sync2 /* synthesis preserve */;

    // Clock gating signal for data_reg
    wire data_reg_clk_en = data_en | !arstn;
    wire gated_clk_a;

    // Clock gating cell instantiation
    CLK_GATE data_reg_clk_gate (
        .CLK(clk_a),
        .EN(data_reg_clk_en),
        .GCLK(gated_clk_a)
    );

    // Data capture in clk_a domain - only update when enabled
    // Using latch-like behavior since data is stable for long periods
    always @(posedge gated_clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
        // else retain value (implicit clock gating)
    end

    // Enable register - simple FF
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Two-stage enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_data_reg;
            en_sync2 <= en_sync1;
        end
    end

    // Data output in clk_b domain with explicit retention
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
        // else retain previous value (explicitly stated)
    end

endmodule