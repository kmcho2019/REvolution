module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Register input data in clk_a domain
    reg [3:0] data_reg;
    reg en_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg <= data_en;
        end
    end

    // Detect enable changes for clock gating
    reg en_prev;
    wire en_change;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) en_prev <= 1'b0;
        else en_prev <= en_reg;
    end
    assign en_change = (en_reg != en_prev);

    // Two-stage synchronizer with clock gating
    reg en_sync1, en_sync2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else if (en_change) begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
        end
    end

    // Output data assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule