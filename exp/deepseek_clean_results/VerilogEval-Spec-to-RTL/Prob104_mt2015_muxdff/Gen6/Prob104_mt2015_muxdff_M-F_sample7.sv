module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    reg feedback_reg;

    always @(posedge clk) begin
        feedback_reg <= q_in;
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= feedback_reg;
        end
    end

endmodule