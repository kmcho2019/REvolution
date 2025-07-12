module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    // Register previous state of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Combinational edge detection signals
    wire rising_edge  = (~a_reg) & a;  // 0->1 transition
    wire falling_edge = a_reg & (~a);  // 1->0 transition

    // Register outputs to generate 1-cycle pulse synchronized to clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rising_edge;
            down <= falling_edge;
        end
    end

endmodule