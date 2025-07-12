module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Internal registers to hold shifted value and count value separately
    reg [3:0] shift_reg;
    reg [3:0] count_reg;
    reg last_op_shift;  // 1 if last operation was shift, 0 if count

    // Asynchronous reset (assumed reset at start, tied internally)
    // since problem doesn't specify reset input, use initial block for simulation
    initial begin
        shift_reg = 4'd0;
        count_reg = 4'd0;
        last_op_shift = 1'b1; // default output from shift_reg at start
        q = 4'd0;
    end

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left by 1, insert data at MSB
            shift_reg <= {data, shift_reg[3:1]};
            last_op_shift <= 1'b1;
        end else if (count_ena) begin
            // Decrement the count_reg
            count_reg <= count_reg - 4'd1;
            last_op_shift <= 1'b0;
        end
        // else no operation, registers hold

        // Update output based on last operation
        if (shift_ena || (!shift_ena && !count_ena && last_op_shift))
            q <= shift_reg;
        else if (count_ena)
            q <= count_reg;
        else
            q <= q; // hold
    end

endmodule