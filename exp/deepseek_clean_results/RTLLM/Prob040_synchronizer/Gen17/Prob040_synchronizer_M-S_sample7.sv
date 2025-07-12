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

    // Clock domain A registers
    reg [WIDTH-1:0] data_reg;
    reg en_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= {WIDTH{1'b0}};
            en_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg <= data_en;
        end
    end

    // Clock domain B two-stage synchronizer
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
            dataout <= {WIDTH{1'b0}};
        end else begin
            en_sync <= {en_sync[0], en_reg};
            if (en_sync[1]) dataout <= data_reg;
        end
    end

endmodule