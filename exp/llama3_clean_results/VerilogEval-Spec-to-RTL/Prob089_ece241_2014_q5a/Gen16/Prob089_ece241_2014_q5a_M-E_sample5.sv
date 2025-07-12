module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] shift_reg; // Assuming 32-bit maximum input length
reg [5:0] counter; // Counter for input bits
reg seen_one; // Flag to indicate if the first '1' has been seen

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        counter <= 0;
        seen_one <= 0;
        z <= 0;
    end else begin
        if (!seen_one) begin
            shift_reg[0] <= x;
            if (x == 1) begin
                seen_one <= 1;
            end else begin
                counter <= counter + 1;
                shift_reg <= {x, shift_reg[31:1]};
            end
        end else begin
            z <= ~shift_reg[31];
            shift_reg <= {1'b0, shift_reg[31:1]};
            if (counter == 0) begin
                seen_one <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

endmodule