module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] shift_reg;
    reg [3:0] count_reg;

    always @(posedge clk) begin
        // Shift register operation
        if (shift_ena)
            shift_reg <= {shift_reg[2:0], data};
        // Count register operation
        if (count_ena)
            count_reg <= count_reg - 1;
    end

    always @(*) begin
        // Output selection depends on which enable is active
        if (shift_ena)
            q = shift_reg;
        else if (count_ena)
            q = count_reg;
        else
            q = q;  // Retain previous output (no change)
    end

endmodule