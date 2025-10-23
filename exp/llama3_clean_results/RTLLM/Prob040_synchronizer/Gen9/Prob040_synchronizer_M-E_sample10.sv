module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] ram[0:1]; // Dual-port RAM
reg [1:0] en_delay; // Delayed enable signal

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        ram[0] <= 4'd0;
        ram[1] <= 4'd0;
    end else if (data_en) begin
        ram[0] <= data_in;
        ram[1] <= ram[0];
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else begin
        en_delay <= {en_delay[0], data_en};
        if (en_delay[1]) begin
            dataout <= ram[1];
        end
    end
end

endmodule