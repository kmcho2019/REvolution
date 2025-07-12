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

// Data Capture and Request
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

// Synchronization and Acknowledge
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_data_reg <= 1'b0;
        en_clap_one <= 1'b0;
        ack <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_data_reg <= req;
        en_clap_one <= en_data_reg;
        if (en_clap_one) begin
            dataout <= data_reg;
            ack <= 1'b1;
        end else begin
            ack <= 1'b0;
        end
    end
end

endmodule