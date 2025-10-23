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
reg [1:0] en_delay;
reg clk_a_gated;

// Clock gating for clk_a to reduce power consumption
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        clk_a_gated <= 1'b0;
    end else if (data_en) begin
        clk_a_gated <= 1'b1;
    end else begin
        clk_a_gated <= 1'b0;
    end
end

// Use the gated clock for the data register update
always @(posedge clk_a_gated or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else begin
        en_delay <= {en_delay[0], data_en};
        if (en_delay[1]) begin
            dataout <= data_reg;
        end
    end
end

endmodule