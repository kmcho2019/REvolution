module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= {q_reg[6:0], d[0]};
            // To implement the shift register behavior while keeping the
            // input data 'd' in mind, we can modify the shift logic to
            // incorporate 'd' into the shift operation.
            q_reg <= (q_reg >> 1) | (d << 7);
        end
    end

    assign q = q_reg;

endmodule