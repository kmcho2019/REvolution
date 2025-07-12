module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // Data register (clock domain A)
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) data_reg <= 4'b0;
        else data_reg <= data_in;
    end

    // Enable register (clock domain A)
    reg en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) en_data_reg <= 1'b0;
        else en_data_reg <= data_en;
    end

    // Two-stage enable synchronization (clock domain B)
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

    // Output assignment using continuous assignment
    reg [3:0] dataout_reg;
    assign dataout = dataout_reg;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) dataout_reg <= 4'b0;
        else if (en_clap_two) dataout_reg <= data_reg;
    end

endmodule