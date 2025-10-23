module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [15:0] shift_reg; // 16-bit one-hot shift register representing count

// Combinational decoder to convert one-hot position to binary count
// Position of the '1' bit corresponds to the count value (0 to 15)
integer i;

always @(posedge clk) begin
    if (reset)
        shift_reg <= 16'b0000_0000_0000_0001; // start with count 0
    else
        // rotate left by 1
        shift_reg <= {shift_reg[14:0], shift_reg[15]};
end

always @(*) begin
    q = 4'd0;
    for (i = 0; i < 16; i = i + 1) begin
        if (shift_reg[i])
            q = i[3:0];
    end
end

endmodule