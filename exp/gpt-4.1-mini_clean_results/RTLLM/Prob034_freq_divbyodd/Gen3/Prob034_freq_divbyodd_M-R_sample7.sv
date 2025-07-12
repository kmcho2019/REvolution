module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] edge_count;

    // Count every edge (posedge and negedge of clk)
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_count <= 0;
            clk_div <= 0;
        end else begin
            if (edge_count == NUM_DIV - 1) begin
                edge_count <= 0;
                clk_div <= ~clk_div;
            end else begin
                edge_count <= edge_count + 1;
            end
        end
    end

endmodule