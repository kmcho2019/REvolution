module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Assuming 8-bit input for simplicity
reg [7:0] inverted_reg;
reg first_one_seen;
reg add_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        inverted_reg <= 0;
        first_one_seen <= 0;
        add_one <= 0;
        z <= 0;
    end else begin
        if (~first_one_seen) begin
            if (x) begin
                first_one_seen <= 1;
                shift_reg <= {shift_reg[6:0], x};
            end else begin
                shift_reg <= {shift_reg[6:0], 0};
            end
        end else begin
            shift_reg <= {shift_reg[6:0], x};
            inverted_reg <= ~shift_reg;
            if (x) begin
                add_one <= 1;
            end
        end
    end
end

always @(*) begin
    if (first_one_seen) begin
        if (add_one) begin
            z = inverted_reg[0] + 1;
        end else begin
            z = inverted_reg[0];
        end
    end else begin
        z = 0;
    end
end

endmodule