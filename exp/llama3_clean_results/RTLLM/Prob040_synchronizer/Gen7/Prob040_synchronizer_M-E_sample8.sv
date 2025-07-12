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
reg [2:0] gray_code_a;
reg [2:0] gray_code_b;
reg       req_a;
reg       ack_b;
reg       req_b;
reg       ack_a;

// Generate Gray code in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        gray_code_a <= 3'd0;
        req_a <= 1'b0;
        data_reg <= 4'd0;
    end else if (data_en) begin
        gray_code_a <= gray_code_a + 1;
        req_a <= 1'b1;
        data_reg <= data_in;
    end else begin
        gray_code_a <= gray_code_a;
        req_a <= 1'b0;
    end
end

// Synchronize Gray code from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        gray_code_b <= 3'd0;
    end else begin
        gray_code_b <= gray_code_a;
    end
end

// Generate ack signal in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack_b <= 1'b0;
    end else if (gray_code_b == 3'd1) begin
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

// Update dataout in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (req_b && ack_b) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule