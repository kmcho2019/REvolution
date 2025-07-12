module TopModule (
    input clk,
    input a,
    output q
);
    wire a_inv;
    reg q_reg;

    assign a_inv = ~a;

    always @(posedge clk) begin
        q_reg <= a_inv;
    end

    assign q = q_reg;

endmodule