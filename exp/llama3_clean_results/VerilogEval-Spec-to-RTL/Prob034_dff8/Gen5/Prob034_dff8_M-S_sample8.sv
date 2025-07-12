module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end

    assign q = q_reg;

endmodule