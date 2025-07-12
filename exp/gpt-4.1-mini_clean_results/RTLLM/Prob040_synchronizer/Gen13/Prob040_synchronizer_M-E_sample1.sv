module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,       // async reset active low, clk_a domain
    input  wire        brstn,       // async reset active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain enable synchronizer registers
    reg en_sync_stage1, en_sync_stage2;

    // Internal register to hold latched output data in clk_b domain before mux
    reg [3:0] dataout_reg;

    // clk_a domain: Sample data_in and data_en when data_en is asserted
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0;
                // Hold previous data_reg value when data_en is low
            end
        end
    end

    // clk_b domain: two-stage synchronizer for en_data_reg crossing to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage1 <= en_data_reg;
            en_sync_stage2 <= en_sync_stage1;
        end
    end

    // clk_b domain: latch dataout_reg to hold output data stable when enable is not active
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout_reg <= 4'd0;
            dataout     <= 4'd0;
        end else begin
            // Multiplexer-based update
            // If enable is active (delayed by 2 clk_b cycles), update output data
            // Otherwise, hold previous output value
            if (en_sync_stage2) begin
                dataout_reg <= data_reg;
                dataout     <= data_reg;
            end else begin
                dataout     <= dataout_reg;
            end
        end
    end

endmodule