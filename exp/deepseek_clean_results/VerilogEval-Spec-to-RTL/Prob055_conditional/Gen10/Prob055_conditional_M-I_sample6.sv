module TopModule (
    input clk,
    input enable,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    reg [7:0] min_ab, min_cd;
    wire [7:0] next_min_ab = (a < b) ? a : b;
    wire [7:0] next_min_cd = (c < d) ? c : d;
    wire [7:0] next_min = (min_ab < min_cd) ? min_ab : min_cd;

    always @(posedge clk) begin
        if (enable) begin
            min_ab <= next_min_ab;
            min_cd <= next_min_cd;
            min <= next_min;
        end
    end

endmodule