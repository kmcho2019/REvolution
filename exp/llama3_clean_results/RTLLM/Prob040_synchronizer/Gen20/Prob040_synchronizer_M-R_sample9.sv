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
reg req;
reg ack;
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;

// Continuous assignment for req
assign req = (arstn && data_en);

// Request generation in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Acknowledgement generation in clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack <= 1'b0;
    end else if (req) begin
        ack <= 1'b1;
    end else begin
        ack <= 1'b0;
    end
end

// Data transmission
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule