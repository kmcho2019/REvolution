module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_data_reg;

    // Clock domain B synchronization registers
    reg en_sync1, en_sync2;

    // Data capture in clk_a domain - only update when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin  // Only update when enabled
            data_reg <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            en_data_reg <= 1'b0;    // Clear enable when data_en goes low
        end
    end

    // Two-stage enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_data_reg;
            en_sync2 <= en_sync1;
        end
    end

    // Data output in clk_b domain - only update when synchronized enable is active
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
        // else retain previous value (implicit)
    end

endmodule