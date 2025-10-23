module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;
    wire rise_edge;
    wire fall_edge;

    // Register input 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Detect edges combinationally
    assign rise_edge = (~a_reg) & a;
    assign fall_edge = a_reg & (~a);

    // Register outputs rise and down to assert one clock cycle after edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_edge;
            down <= fall_edge;
        end
    end

endmodule