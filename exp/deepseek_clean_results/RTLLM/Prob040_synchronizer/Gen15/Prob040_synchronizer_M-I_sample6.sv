module synchronizer #(
    parameter WIDTH = 4
) (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [WIDTH-1:0] data_in,
    input wire data_en,
    output reg [WIDTH-1:0] dataout
);

    // Data capture in clk_a domain with clock gating
    reg [WIDTH-1:0] data_reg;
    reg en_data_reg;
    wire data_reg_clken = data_en & (data_in != data_reg);
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= {WIDTH{1'b0}};
            en_data_reg <= 1'b0;
        end else begin
            if (data_reg_clken) data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Single-stage synchronizer with output register in clk_b domain
    reg en_sync;
    reg [WIDTH-1:0] data_sync;
    
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_sync <= 1'b0;
            dataout <= {WIDTH{1'b0}};
        end else begin
            en_sync <= en_data_reg;
            if (en_sync) dataout <= data_reg;
        end
    end

endmodule