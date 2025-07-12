module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data registers in clk_a domain
    reg [3:0] data_reg;
    reg [3:0] prev_data_in;
    reg en_data_reg;
    reg data_changed;

    // Synchronization registers in clk_b domain
    reg en_clap_one, en_clap_two;

    // Data change detection and capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            prev_data_in <= 4'b0;
            en_data_reg <= 1'b0;
            data_changed <= 1'b0;
        end else begin
            prev_data_in <= data_in;
            data_changed <= (data_in != prev_data_in);
            
            // Only update data_reg when data_en is high and data has changed
            if (data_en && (data_changed || !en_data_reg)) begin
                data_reg <= data_in;
            end
            
            en_data_reg <= data_en;
        end
    end

    // Enable signal synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Data output in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
        // else retain previous value (implicit)
    end

endmodule