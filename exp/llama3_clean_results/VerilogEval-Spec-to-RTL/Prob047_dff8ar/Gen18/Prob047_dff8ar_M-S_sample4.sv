// Simplified TopModule with 8 D flip-flops and active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Reg to hold the output value, initialized with reset value
    reg [7:0] q_reg = 8'b0;

    // Always block triggered on positive edge of clk or posedge of areset
    always @(posedge clk or posedge areset) begin
        // If areset is high, reset q_reg to 0
        if (areset) begin
            q_reg <= 8'b0;
        end 
        // Otherwise, update q_reg with the input d on the positive edge of clk
        else begin
            q_reg <= d;
        end
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule