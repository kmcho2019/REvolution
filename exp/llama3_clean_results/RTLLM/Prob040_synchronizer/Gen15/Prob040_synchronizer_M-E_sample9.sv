module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] gray_code; // Gray code encoded data
reg request; // Request signal from transmitter
reg acknowledge; // Acknowledge signal from receiver
reg [3:0] data_reg; // Register to store received data

// Transmitter module (clk_a domain)
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        gray_code <= 4'd0;
        request <= 1'd0;
    end else if (data_en) begin
        // Gray code encoding
        gray_code <= data_in ^ (data_in >> 1);
        request <= 1'd1;
    end else begin
        request <= 1'd0;
    end
end

// Receiver module (clk_b domain)
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg <= 4'd0;
        acknowledge <= 1'd0;
    end else if (request) begin
        // Gray code decoding
        data_reg <= gray_code ^ (gray_code >> 1);
        acknowledge <= 1'd1;
    end else begin
        acknowledge <= 1'd0;
    end
end

// Assign output dataout
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (acknowledge) begin
        dataout <= data_reg;
    end
end

endmodule