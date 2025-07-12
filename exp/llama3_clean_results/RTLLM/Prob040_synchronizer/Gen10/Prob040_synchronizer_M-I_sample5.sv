module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Data register
reg en_delay; // Delayed enable signal
reg prev_en; // Previous enable signal

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        prev_en <= 1'b0;
    end else if (data_en) begin
        // Implement clock gating
        if (prev_en == 1'b0) begin
            data_reg <= data_in;
        end
        prev_en <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 1'b0;
        dataout <= 4'd0;
    end else begin
        // Simplify the enable signal delay
        en_delay <= prev_en && data_en;
        if (en_delay) begin
            dataout <= data_reg;
        end
    end
end

endmodule