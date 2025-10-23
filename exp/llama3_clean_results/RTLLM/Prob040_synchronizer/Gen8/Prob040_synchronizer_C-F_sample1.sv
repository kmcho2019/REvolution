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
reg en_delay;
reg req_a;
reg ack_b;

// Generate req signal in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req_a <= 1'b0;
        data_reg <= 4'd0;
    end else if (data_en) begin
        req_a <= 1'b1;
        data_reg <= data_in;
    end else begin
        req_a <= 1'b0;
    end
end

// Synchronize req signal from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack_b <= 1'b0;
        en_delay <= 1'b0;
    end else begin
        ack_b <= req_a;
        en_delay <= data_en;
    end
end

// Update dataout in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (ack_b && en_delay) begin
        dataout <= data_reg;
    end
end

endmodule