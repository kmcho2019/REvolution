module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       req_a;
reg       ack_b;
reg       req_b;
reg       ack_a;
reg [3:0] dataout_reg;

// Generate req signal in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req_a <= 1'b0;
        en_data_reg <= 1'b0;
        data_reg <= 4'd0;
    end else if (data_en) begin
        req_a <= 1'b1;
        en_data_reg <= data_en;
        data_reg <= data_in;
    end else begin
        req_a <= 1'b0;
        en_data_reg <= 1'b0;
    end
end

// Synchronize req signal from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        req_b <= 1'b0;
    end else begin
        req_b <= req_a;
    end
end

// Generate ack signal in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack_b <= 1'b0;
    end else if (req_b) begin
        ack_b <= 1'b1;
    end else begin
        ack_b <= 1'b0;
    end
end

// Synchronize ack signal from clock domain B to clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        ack_a <= 1'b0;
    end else begin
        ack_a <= ack_b;
    end
end

// Update dataout_reg in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'd0;
    end else if (req_b && ack_b && en_data_reg) begin
        dataout_reg <= data_reg;
    end else begin
        dataout_reg <= dataout_reg;
    end
end

assign dataout = dataout_reg;

endmodule