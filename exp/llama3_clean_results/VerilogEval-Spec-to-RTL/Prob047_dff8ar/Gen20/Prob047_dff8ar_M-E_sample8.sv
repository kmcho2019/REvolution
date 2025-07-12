// Novel implementation of TopModule using a single 8-bit register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0; // Asynchronous reset to all zeros
        end else begin
            q_reg <= d; // Update q_reg with input d at positive edge of clk
        end
    end

    assign q = q_reg; // Continuous assignment of q_reg to output q

endmodule