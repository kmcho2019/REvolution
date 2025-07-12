module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] edge_count;
    reg clk_div_reg;
    reg clk_prev;
    
    // Edge detection
    wire clk_edge = (clk ^ clk_prev);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_prev <= 0;
        end else begin
            clk_prev <= clk;
        end
    end

    // Edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_count <= 0;
            clk_div_reg <= 0;
        end else if (clk_edge) begin
            if (edge_count == NUM_DIV - 1) begin
                edge_count <= 0;
            end else begin
                edge_count <= edge_count + 1;
            end
            
            // Toggle clock at half periods
            if (edge_count == (NUM_DIV - 1)/2) begin
                clk_div_reg <= 1;
            end else if (edge_count == NUM_DIV - 1) begin
                clk_div_reg <= 0;
            end
        end
    end

    assign clk_div = clk_div_reg;

endmodule