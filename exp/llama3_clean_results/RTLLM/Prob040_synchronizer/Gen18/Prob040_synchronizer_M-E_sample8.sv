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
reg clk_sync;
reg clk_gated;
reg [1:0] en_delay;

// Self-timed clock generator
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        clk_sync <= 1'b0;
    end else begin
        // Delay-locked loop (DLL) to generate synchronized clock signal
        clk_sync <= clk_b;
    end
end

// Clock-gated register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (clk_gated) begin
        data_reg <= data_in;
    end
end

// Clock gating
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= data_en;
    end
end

// Enable signal delay
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'b00;
    end else begin
        en_delay <= {en_delay[0], data_en};
    end
end

// Output assignment
always @(posedge clk_sync or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_delay[1]) begin
        dataout <= data_reg;
    end
end

endmodule