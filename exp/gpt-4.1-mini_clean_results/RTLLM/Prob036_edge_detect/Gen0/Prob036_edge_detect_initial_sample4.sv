module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;

            if (~a_dly & a)
                rise <= 1'b1;
            else if (a_dly & ~a)
                down <= 1'b1;

            a_dly <= a;
        end
    end

endmodule