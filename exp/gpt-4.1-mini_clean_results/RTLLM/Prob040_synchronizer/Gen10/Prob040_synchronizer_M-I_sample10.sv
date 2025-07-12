module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Data and enable registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Previous data_en for edge detection in clk_a domain
    reg prev_data_en;

    // Synchronizer output for enable signal crossing clk_a->clk_b
    wire synced_en;

    // clk_a domain: latch data_in only once at rising edge of data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
            prev_data_en <= 1'b0;
        end else begin
            prev_data_en <= data_en;
            // Detect rising edge of data_en to latch data and en_data_reg
            if (~prev_data_en & data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                // Clear en_data_reg after one cycle
                en_data_reg <= 1'b0;
            end
        end
    end

    // Two-flip-flop synchronizer module instantiated here
    synchronizer_sync_2ff en_sync (
        .clk(clk_b),
        .arstn(brstn),
        .async_in(en_data_reg),
        .sync_out(synced_en)
    );

    // Output data logic in clk_b domain:
    // When synced_en is asserted, latch data_reg; else keep previous dataout
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (synced_en) begin
            dataout <= data_reg;
        end
    end

endmodule


// Two-flip-flop synchronizer module for crossing clk_a to clk_b domain
module synchronizer_sync_2ff (
    input  wire clk,
    input  wire arstn,      // async active-low reset
    input  wire async_in,
    output wire sync_out
);

    reg ff1, ff2;

    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            ff1 <= async_in;
            ff2 <= ff1;
        end
    end

    assign sync_out = ff2;

endmodule