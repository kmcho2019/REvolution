module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output [7:0] q;

    reg [7:0] q_reg;

    always @(posedge clk) begin
        q_reg <= {q_reg[6:0], d[7]};
    end

    assign q = q_reg;
endmodule