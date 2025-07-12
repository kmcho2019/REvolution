module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else hold data_reg
        end
    end

    // clk_b domain: two-stage synchronization of en_data_reg
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

    // clk_b domain: data synchronization register clock enabled by en_clap_two
    reg [3:0] data_sync;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync <= 4'd0;
        end else if (en_clap_two) begin
            data_sync <= data_reg;
        end
        // else hold data_sync
    end

    // clk_b domain: output register updates dataout with data_sync only when en_clap_two is high,
    // else holds previous value
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            dataout <= data_sync;
        end
        // else hold dataout
    end

endmodule