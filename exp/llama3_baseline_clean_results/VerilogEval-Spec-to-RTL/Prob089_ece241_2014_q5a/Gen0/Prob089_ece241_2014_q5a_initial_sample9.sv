module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] shift_reg = 32'd0;  // 32-bit shift register to accumulate input bits
reg [31:0] complement_reg = 32'd0;  // 32-bit register to hold the 2's complement
reg invert_flag = 1'b0;  // flag to determine whether to invert the output

always @(posedge clk or posedge areset) begin
    if (areset) begin  // asynchronous reset
        shift_reg <= 32'd0;
        complement_reg <= 32'd0;
        invert_flag <= 1'b0;
    end else begin
        if (invert_flag) begin  // if we are in the process of calculating the 2's complement
            shift_reg <= {shift_reg[30:0], x};  // shift input bit into the shift register
            if (x == 1'b1) begin  // if the input bit is 1, set the carry flag
                complement_reg <= {31{1'b1}} - shift_reg + 1'b1;  // calculate the 2's complement
            end else begin
                complement_reg <= {31{1'b1}} - shift_reg;  // calculate the 2's complement
            end
        end else begin  // if we are not in the process of calculating the 2's complement
            shift_reg <= {shift_reg[30:0], x};  // shift input bit into the shift register
        end
    end
end

always @(posedge areset) begin  // on reset, set the invert flag and reset the registers
    invert_flag <= 1'b1;
end

assign z = (invert_flag) ? complement_reg[0] : shift_reg[0];  // output the least significant bit of the accumulated value or the 2's complement

endmodule