module transmitter (
    input clk_a,
    input arstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] data_reg,
    output reg req
);

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        req <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

endmodule

module receiver (
    input clk_b,
    input brstn,
    input [3:0] data_reg,
    input req,
    output reg [3:0] dataout
);

reg en_data_reg;
reg en_clap_one;
reg en_clap_two;
reg ack;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_data_reg <= 1'b0;
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        ack <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_data_reg <= req;
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
            ack <= 1'b1;
        end else begin
            ack <= 1'b0;
        end
    end
end

assign ack = en_clap_two;

endmodule

module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

transmitter u_transmitter (
    .clk_a(clk_a),
    .arstn(arstn),
    .data_in(data_in),
    .data_en(data_en),
    .data_reg(dataout),
    .req(data_en)
);

receiver u_receiver (
    .clk_b(clk_b),
    .brstn(brstn),
    .data_reg(data_in),
    .req(data_en),
    .dataout(dataout)
);

endmodule