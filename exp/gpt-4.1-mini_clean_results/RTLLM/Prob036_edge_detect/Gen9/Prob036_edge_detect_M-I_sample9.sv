module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Edge detection: compare current 'a' with previous 'a_reg'
            rise <= (~a_reg) & a;
            down <= a_reg & (~a);
            a_reg <= a;
        end
    end

endmodule