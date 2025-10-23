module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Data register clocked by clk_a
reg req; // Request signal
reg ack; // Acknowledge signal
reg en_data_reg; // Enable data register
reg en_clap_one; // First D flip-flop
reg en_clap_two; // Second D flip-flop

// Data register and request signal generation
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        req <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        req <= 1'b1;
    end else if (ack) begin
        req <= 1'b0;
    end
end

// Enable signal delay and handshake protocol
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

endmodule