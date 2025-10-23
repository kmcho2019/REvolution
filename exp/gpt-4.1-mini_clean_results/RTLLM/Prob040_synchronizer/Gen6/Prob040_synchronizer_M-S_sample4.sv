module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async active-low reset clk_a domain
    input  wire        brstn,      // async active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain to sample data_in and data_en
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Enable control registers in clk_b domain with two-stage delay
    reg en_clap_one, en_clap_two;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Two-stage synchronizer for data crossing clk domains
    reg [3:0] data_sync_one, data_sync_two;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync_one <= 4'b0;
            data_sync_two <= 4'b0;
        end else begin
            data_sync_one <= data_reg;
            data_sync_two <= data_sync_one;
        end
    end

    // Output data assignment: update only when delayed enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_sync_two;
        end
        // else retain previous dataout
    end

endmodule