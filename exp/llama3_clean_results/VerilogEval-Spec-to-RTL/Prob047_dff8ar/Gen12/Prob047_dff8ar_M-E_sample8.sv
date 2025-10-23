module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;
    wire       ce; // Clock enable

    // Simple condition for clock enable: update when input changes
    assign ce = (d != q_reg);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else if (ce) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule