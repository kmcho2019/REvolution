module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async active-low reset clk_a domain
    input  wire        brstn,      // async active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg_a;
    reg       en_reg_a;

    // Sample data_in and data_en at clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a   <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a   <= data_en;
        end
    end

    // clk_b domain: enable signal synchronizer and filter
    reg [2:0] en_shift_b;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_shift_b <= 3'b0;
        end else begin
            // Shift in the clk_a domain sampled enable signal
            en_shift_b <= {en_shift_b[1:0], en_reg_a};
        end
    end

    // Determine when enable is stable high (all ones)
    wire en_stable = (en_shift_b == 3'b111);

    // clk_b domain: two-stage synchronizer for data crossing clk domains
    reg [3:0] data_sync_b_1;
    reg [3:0] data_sync_b_2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync_b_1 <= 4'b0;
            data_sync_b_2 <= 4'b0;
        end else begin
            data_sync_b_1 <= data_reg_a;
            data_sync_b_2 <= data_sync_b_1;
        end
    end

    // Output data register update control
    // Update dataout only when enable stable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_stable) begin
            dataout <= data_sync_b_2;
        end
        // else retain previous dataout (no else needed)
    end

endmodule