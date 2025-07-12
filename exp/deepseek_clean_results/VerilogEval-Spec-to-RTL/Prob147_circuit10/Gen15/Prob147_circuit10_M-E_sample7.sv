module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
reg [1:0] zero_counter = 2'b0;
reg one_cycle_flag = 1'b0;

always @(posedge clk) begin
    // Reset condition 1: a=b=0 for exactly 4 cycles
    if (a == 0 && b == 0) begin
        zero_counter <= zero_counter + 1;
        if (zero_counter == 2'b11) begin
            state_reg <= 1'b0;
            zero_counter <= 2'b0;
        end
    end
    else begin
        zero_counter <= 2'b0;
    end

    // Reset condition 2: a=b=1 for exactly 1 cycle
    if (a == 1 && b == 1) begin
        if (one_cycle_flag) begin
            state_reg <= 1'b0;
            one_cycle_flag <= 1'b0;
        end
        else begin
            one_cycle_flag <= 1'b1;
        end
    end
    else begin
        one_cycle_flag <= 1'b0;
    end

    // Toggle condition: a≠b
    if (a != b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - simple XOR
assign q = state_reg ^ b;
assign state = state_reg;

endmodule