module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] gray_code;
reg [3:0] sync_gray_code;
reg [3:0] prev_dataout;
reg [3:0] curr_dataout;

// Generate Gray code
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        gray_code <= 4'd0;
    end else if (data_en) begin
        gray_code <= {data_in[3] ^ data_in[2], data_in[2] ^ data_in[1], data_in[1] ^ data_in[0], data_in[0]};
    end else begin
        gray_code <= gray_code;
    end
end

// Synchronize Gray code
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        sync_gray_code <= 4'd0;
    end else begin
        sync_gray_code <= gray_code;
    end
end

// Decode Gray code
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        curr_dataout <= 4'd0;
    end else begin
        curr_dataout <= {sync_gray_code[3] ^ sync_gray_code[2], sync_gray_code[2] ^ sync_gray_code[1], sync_gray_code[1] ^ sync_gray_code[0], sync_gray_code[0]};
    end
end

// MUX-based selection
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (data_en) begin
        dataout <= curr_dataout;
    end else begin
        dataout <= prev_dataout;
    end
end

always @(posedge clk_b) begin
    prev_dataout <= dataout;
end

endmodule