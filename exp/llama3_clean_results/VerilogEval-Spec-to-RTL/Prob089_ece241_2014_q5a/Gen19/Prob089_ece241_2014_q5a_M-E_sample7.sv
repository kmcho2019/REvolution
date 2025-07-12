module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Assuming 8-bit input sequence
reg start;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        start <= 0;
        z <= 0;
    end else begin
        if (!start) begin
            if (x) begin
                start <= 1;
                shift_reg[0] <= x;
            end
        end else begin
            shift_reg <= {shift_reg[6:0], x};
            if (x) begin
                z <= ~x;
            end else begin
                z <= x;
            end
        end
    end
end

endmodule