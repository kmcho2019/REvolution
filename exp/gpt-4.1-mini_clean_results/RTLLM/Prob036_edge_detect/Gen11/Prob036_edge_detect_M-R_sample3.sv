module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_reg, a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg  <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            a_prev <= a_reg;
            a_reg  <= a;
        end
    end

    assign rise = (~a_prev) & a_reg;
    assign down = a_prev & (~a_reg);

endmodule