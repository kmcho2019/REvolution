module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register implementation (01 = A, 10 = B)
    reg [1:0] shift_reg;

    // Shift operation:
    // - In A: shift in x (becomes B if x=1)
    // - In B: always shift in 1
    wire shift_in = shift_reg[1] ? 1'b1 : x;

    // Output logic: z = x when in A (shift_reg[0]), else ~x
    assign z = shift_reg[0] ? x : ~x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 2'b01;  // Reset to state A
        end
        else begin
            shift_reg <= {shift_reg[0], shift_in};
        end
    end

endmodule