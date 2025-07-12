module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Assuming 8-bit input for demonstration
reg seen_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        seen_one <= 0;
        z <= 0;
    end else begin
        shift_reg <= {shift_reg[6:0], x}; // Shift input bits into register
        if (~seen_one && x) begin
            seen_one <= 1;
        end
        if (seen_one) begin
            z <= ~shift_reg[0]; // Invert output bits after first 1 is seen
        end else begin
            z <= shift_reg[0]; // Output bits as is before first 1 is seen
        end
    end
end

endmodule