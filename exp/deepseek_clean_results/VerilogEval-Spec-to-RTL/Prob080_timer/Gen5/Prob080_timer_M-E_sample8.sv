module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    wire [9:0] next_shift;

    // Convert loaded data to one-hot position (1 << (data-1))
    // Special case: data=0 means immediate timeout (1'b1 in LSB)
    wire [9:0] loaded_onehot = (data == 10'b0) ? 10'b0000000001 :
                              (10'b1 << (data - 1));

    // Shift right unless loading new value
    assign next_shift = load ? loaded_onehot : 
                       {1'b0, shift_reg[9:1]};

    always @(posedge clk) begin
        shift_reg <= next_shift;
    end

    // Terminal count is when LSB is 1
    assign tc = shift_reg[0];

endmodule