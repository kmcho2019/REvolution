module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_buffer;
reg req;
reg ack;
reg [3:0] output_buffer;

// Data Buffer
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_buffer <= 4'd0;
    end else if (data_en) begin
        data_buffer <= data_in;
    end
end

// Request Signal
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req <= 1'b0;
    end else if (data_en) begin
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

// Handshake Controller
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        ack <= 1'b0;
    end else if (req && ack) begin
        ack <= 1'b0;
    end else if (req) begin
        ack <= 1'b1;
    end
end

// Clock Domain Crossing (CDC) Module
reg [3:0] cdc_data;
reg cdc_req;
reg cdc_ack;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        cdc_data <= 4'd0;
        cdc_req <= 1'b0;
        cdc_ack <= 1'b0;
    end else if (req &&!cdc_req) begin
        cdc_data <= data_buffer;
        cdc_req <= 1'b1;
    end else if (cdc_req && cdc_ack) begin
        cdc_req <= 1'b0;
    end else if (cdc_req) begin
        cdc_ack <= 1'b1;
    end
end

// Output Buffer
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        output_buffer <= 4'd0;
    end else if (cdc_ack) begin
        output_buffer <= cdc_data;
    end
end

assign dataout = output_buffer;

endmodule