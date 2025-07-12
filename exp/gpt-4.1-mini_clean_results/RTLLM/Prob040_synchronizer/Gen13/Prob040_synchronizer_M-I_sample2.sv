module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // -------- clk_a domain --------
    // Register to hold input data when data_en is high
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end

    // Register to hold enable signal in clk_a domain
    reg en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // -------- clk_b domain --------
    // Synchronize en_data_reg into clk_b domain through two flip-flops (delayed by two clk_b cycles)
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

    // Data output register on clk_b domain with mux controlled by delayed enable
    // When en_clap_two is high, output data_reg, else hold previous dataout
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_clap_two) begin
                dataout <= data_reg;
            end
            // else hold previous value
        end
    end

endmodule