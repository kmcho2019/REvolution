module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    // Only update a_dly when 'a' changes to reduce unnecessary toggling and save power
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else if (a != a_dly)
            a_dly <= a;
    end

    // Combinational edge detection
    wire rising_edge  = (~a_dly) & a;
    wire falling_edge = a_dly & (~a);

    // Register outputs pulse for one clock cycle on detected edges
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