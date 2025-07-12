module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    
    // clk_b domain signals
    reg en_sync1, en_sync2;
    reg [3:0] dataout_reg;

    // Input data capture (clk_a domain)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Two-stage enable synchronizer (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {en_sync2, en_sync1} <= 2'b0;
        end else begin
            {en_sync2, en_sync1} <= {en_sync1, data_en};
        end
    end

    // Output data register (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout_reg <= 4'b0;
        end else if (en_sync2) begin
            dataout_reg <= data_reg;
        end
    end

    // Output assignment
    assign dataout = dataout_reg;

endmodule