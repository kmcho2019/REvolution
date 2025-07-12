// Novel TopModule implementation with a single register and built-in reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Define a reg with an initial value of 0
    reg [7:0] q_reg = 8'b0;

    // Always block triggered on positive edge of clk
    always @(posedge clk) begin
        // If areset is high, reset q_reg to 0
        if (areset) begin
            q_reg <= 8'b0;
        end 
        // Otherwise, update q_reg with the input d
        else begin
            q_reg <= d;
        end
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule