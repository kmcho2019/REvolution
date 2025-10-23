module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_reg;

    // Synchronizer flip-flops for en_reg crossing to clk_b domain
    reg en_sync_ff1, en_sync_ff2;
    reg en_latch; // latched enable used for dataout gating

    wire en_sync; // synchronized enable used for output update

    // Data register updated only when data_en is high, async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Enable register updated every clk_a cycle with async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_reg <= 1'b0;
        end else begin
            en_reg <= data_en;
        end
    end

    // Two flip-flop synchronizer with clock enable to reduce toggling
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_ff1 <= 1'b0;
            en_sync_ff2 <= 1'b0;
        end else begin
            // Clock enable: update flip-flops only when en_reg differs from last stage
            if (en_sync_ff1 != en_reg)
                en_sync_ff1 <= en_reg;
            if (en_sync_ff2 != en_sync_ff1)
                en_sync_ff2 <= en_sync_ff1;
        end
    end

    // Latch stage for stable enable, asynchronously reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_latch <= 1'b0;
        end else begin
            // Latch enable when en_sync_ff2 asserted, clear when deasserted to reduce glitches
            if (en_sync_ff2)
                en_latch <= 1'b1;
            else
                en_latch <= 1'b0;
        end
    end

    assign en_sync = en_latch;

    // Output data update, clocked by clk_b with async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_sync) begin
            dataout <= data_reg;
        end
        // else hold previous value implicitly
    end

endmodule