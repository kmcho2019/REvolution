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
reg       req;
reg       ack;
reg [3:0] dataout_reg;
reg [1:0] en_delay;

// Update data_reg and en_data_reg in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end else begin
        en_data_reg <= 1'b0;
    end
end

// Generate req signal in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req <= 1'b0;
    end else if (en_data_reg) begin
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

// Synchronize req signal from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_delay <= 2'd0;
    end else begin
        en_delay <= {en_delay[0], req};
    end
end

// Generate ack signal in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack <= 1'b0;
    end else if (en_delay[1]) begin
        ack <= 1'b1;
    end else begin
        ack <= 1'b0;
    end
end

// Update dataout_reg in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'd0;
    end else if (ack && en_delay[1]) begin
        dataout_reg <= data_reg;
    end else begin
        dataout_reg <= dataout_reg;
    end
end

assign dataout = dataout_reg;

endmodule