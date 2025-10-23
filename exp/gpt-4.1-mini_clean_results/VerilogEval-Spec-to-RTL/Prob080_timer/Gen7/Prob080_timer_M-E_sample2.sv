module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    wire [9:0] next_shift_reg;

    // When loading, load 'data' as the initial shift register state.
    // Else shift right by one bit, inserting zero on the left.
    assign next_shift_reg = load ? data : (shift_reg != 10'b0 ? {1'b0, shift_reg[9:1]} : 10'b0);

    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

    // Terminal count when shift register is zero
    assign tc = (shift_reg == 10'b0);

endmodule