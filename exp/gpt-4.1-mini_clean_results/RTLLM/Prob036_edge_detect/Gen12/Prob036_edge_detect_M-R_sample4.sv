module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    wire rising_edge  = (~a_d) & a;
    wire falling_edge = a_d & (~a);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            a_d   <= a;
            rise  <= rising_edge;
            down  <= falling_edge;
        end
    end

endmodule