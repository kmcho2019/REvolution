module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Register to store data_in
reg data_en_reg; // Register to store data_en
reg req_a; // Request signal for clk_a domain
reg ack_a; // Acknowledge signal for clk_a domain
reg req_b; // Request signal for clk_b domain
reg ack_b; // Acknowledge signal for clk_b domain

// Handshake control unit
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req_a <= 1'd0;
        ack_a <= 1'd0;
    end else if (data_en) begin
        req_a <= 1'd1;
    end else if (ack_a) begin
        req_a <= 1'd0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        req_b <= 1'd0;
        ack_b <= 1'd0;
    end else if (req_a) begin
        req_b <= 1'd1;
    end else if (ack_b) begin
        req_b <= 1'd0;
    end
end

// Data register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (req_a && data_en) begin
        data_reg <= data_in;
    end
end

// Enable register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_en_reg <= 1'd0;
    end else begin
        data_en_reg <= data_en;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (req_b && ack_b) begin
        dataout <= data_reg;
    end
end

// Acknowledge signal generation
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        ack_a <= 1'd0;
    end else if (req_a && data_en) begin
        ack_a <= 1'd1;
    end else if (!req_a) begin
        ack_a <= 1'd0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack_b <= 1'd0;
    end else if (req_b && data_en_reg) begin
        ack_b <= 1'd1;
    end else if (!req_b) begin
        ack_b <= 1'd0;
    end
end

endmodule