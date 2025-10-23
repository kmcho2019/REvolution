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
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain registers for enable synchronization
    reg en_clap_one, en_clap_two;

    // clk_a domain: async reset, update data_reg and en_data_reg only when data_en is high
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
                // hold data_reg value as data_in is stable only during data_en high
            end
        end
    end

    // clk_b domain: two-stage synchronization of en_data_reg with async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // output data mux controlled by synchronized enable, async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= (en_clap_two) ? data_reg : dataout;
        end
    end

endmodule