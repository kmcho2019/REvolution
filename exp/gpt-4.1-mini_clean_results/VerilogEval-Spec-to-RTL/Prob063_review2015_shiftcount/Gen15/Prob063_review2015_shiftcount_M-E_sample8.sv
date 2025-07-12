module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg [3:0] shift_reg;
    reg [3:0] count_reg;

    // Shift operation: shift left, input data into MSB
    always @(posedge clk) begin
        if (shift_ena)
            shift_reg <= {data, shift_reg[3:1]};
        else
            shift_reg <= shift_reg;
    end

    // Count operation: decrement by 1 modulo 16
    always @(posedge clk) begin
        if (count_ena)
            count_reg <= count_reg - 1;
        else
            count_reg <= count_reg;
    end

    // Output logic: select shift or count register based on enables
    // Since both enables not active at the same time, priority doesn't matter
    always @(posedge clk) begin
        if (shift_ena)
            q <= shift_reg;
        else if (count_ena)
            q <= count_reg;
        else
            q <= q;
    end

endmodule