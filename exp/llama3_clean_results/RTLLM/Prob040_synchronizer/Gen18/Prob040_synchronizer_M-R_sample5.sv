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
reg [1:0] en_clap;

// Sequential logic
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap <= 2'd0;
    end else begin
        en_clap <= {en_clap[0], data_en};
    end
end

// Combinational logic
assign dataout = (en_clap[1]) ? data_reg : dataout;

endmodule