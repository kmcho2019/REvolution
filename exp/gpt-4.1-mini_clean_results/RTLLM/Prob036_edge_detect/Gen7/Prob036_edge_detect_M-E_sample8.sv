module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d0, a_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d0 <= 1'b0;
            a_d1 <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_d0 <= a;
            a_d1 <= a_d0;
            rise <= (a_d0 & ~a_d1);
            down <= (~a_d0 & a_d1);
        end
    end

endmodule