module synchronizer (
    input               clk_a,
    input               clk_b,
    input               arstn,
    input               brstn,
    input       [3:0]   data_in,
    input               data_en,
    output reg  [3:0]   dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Enable synchronization registers and output update in clk_b domain
    reg en_clap_one, en_clap_two;

    // Data and enable registers update only when data_en is high in clk_a domain
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
                // data_reg holds its value since data_in does not change outside data_en high
            end
        end
    end

    // Combine enable synchronization and output update into one clk_b domain always block
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            // Synchronize en_data_reg into clk_b domain with 2-stage flip-flops
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // Update output data when synchronized enable is asserted, else hold value
            if (en_clap_two) begin
                dataout <= data_reg;
            end
            // No else needed since dataout keeps its value by default in registers
        end
    end

endmodule