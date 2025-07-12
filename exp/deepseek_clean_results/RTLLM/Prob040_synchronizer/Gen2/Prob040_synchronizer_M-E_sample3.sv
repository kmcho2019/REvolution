module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else begin
            data_reg <= data_in;
        end
    end

    // Toggle generator for enable in clk_a domain
    reg toggle_a;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            toggle_a <= 1'b0;
        end else if (data_en) begin
            toggle_a <= ~toggle_a;
        end
    end

    // Two-stage toggle synchronizer in clk_b domain
    reg toggle_b1, toggle_b2, toggle_b2_prev;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            toggle_b1 <= 1'b0;
            toggle_b2 <= 1'b0;
            toggle_b2_prev <= 1'b0;
        end else begin
            toggle_b1 <= toggle_a;
            toggle_b2 <= toggle_b1;
            toggle_b2_prev <= toggle_b2;
        end
    end

    // Edge detector for synchronized toggle
    wire sync_pulse = toggle_b2 ^ toggle_b2_prev;

    // Output register in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (sync_pulse) begin
            dataout <= data_reg;
        end
    end

endmodule