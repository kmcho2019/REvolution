module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Clock domain B registers
    reg en_clap_one, en_clap_two;
    
    // Data path in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end
    
    // Enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {en_clap_two, en_clap_one} <= 2'b00;
        end else begin
            {en_clap_two, en_clap_one} <= {en_clap_one, en_data_reg};
        end
    end
    
    // Output assignment with explicit enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= en_clap_two ? data_reg : dataout;
        end
    end

endmodule