module synchronizer (
    input            clk_a,
    input            clk_b,
    input            arstn,
    input            brstn,
    input      [3:0] data_in,
    input            data_en,
    output reg [3:0] dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain to synchronize enable
    reg en_clap_one, en_clap_two;

    // Data register update in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end

    // Enable register update in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Synchronize enable signal to clk_b domain with 2-stage flip-flops
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output data assignment in clk_b domain with mux based on synchronized enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_clap_two) begin
                dataout <= data_reg;
            end // else retain previous dataout
        end
    end

endmodule