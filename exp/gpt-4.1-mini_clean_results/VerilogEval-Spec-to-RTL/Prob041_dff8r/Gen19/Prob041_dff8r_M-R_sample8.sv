module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    reg [7:0] q_reg;

    always @(posedge clk) begin
        if (reset)
            q_reg <= 8'b0;
        else
            q_reg <= d;
    end

    assign q = q_reg;

endmodule