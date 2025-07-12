module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg request_sync; // Synchronized request signal
reg [3:0] data_reg; // Data register clocked by clk_b

// Asynchronous request signal generation
wire request = data_en;

// Synchronizer circuit for request signal
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        request_sync <= 1'd0;
    end else begin
        request_sync <= request;
    end
end

// Data capture and output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg <= 4'd0;
        dataout <= 4'd0;
    end else if (request_sync) begin
        data_reg <= data_in;
        dataout <= data_reg;
    end
end

endmodule