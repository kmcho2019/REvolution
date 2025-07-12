module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load)
            shift_reg <= {10{1'b1}};  // Load all 1s when data is loaded
        else if (|shift_reg)          // Only shift if not zero
            shift_reg <= {shift_reg[8:0], 1'b0};  // Shift left with 0 input
    end

    assign tc = ~(|shift_reg);  // Terminal count when all bits are 0

endmodule