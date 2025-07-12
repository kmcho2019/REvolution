module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg shift_ena_reg, count_ena_reg;
wire shift_active = shift_ena_reg;
wire count_active = count_ena_reg;

always @(posedge clk) begin
    shift_ena_reg <= shift_ena;
    count_ena_reg <= count_ena;
end

always @(posedge clk) begin
    if (shift_active) begin
        q <= {q[2:0], data};  // Shift operation
    end
    else if (count_active) begin
        q <= q - 1'b1;        // Count operation
    end
    // else hold value
end

endmodule