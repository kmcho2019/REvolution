module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg en_delay_one, en_delay_two;

// Use always block for clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Use always block for clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay_one <= 1'b0;
        en_delay_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_delay_one <= data_en;
        en_delay_two <= en_delay_one;
        if (en_delay_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule