module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [1023:0] shift_reg;  // Large enough to hold maximum count (1023)
    wire [1023:0] next_shift_reg;

    // Load logic: Fill with 'data' number of 1's, rest 0's
    // Shift logic: Right shift by 1 and insert 0
    assign next_shift_reg = load ? 
                          ((1 << data) - 1) : 
                          {1'b0, shift_reg[1023:1]};

    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

    // Terminal count is when LSB is 0 (all 1's have been shifted out)
    assign tc = ~shift_reg[0];

endmodule