module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] binary_reg; // Assuming 8-bit for simplicity, can be adjusted
reg [3:0] bit_counter;
reg first_one_received;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        binary_reg <= 0;
        bit_counter <= 0;
        first_one_received <= 0;
        z <= 0;
    end else begin
        if (!first_one_received && x) begin
            first_one_received <= 1;
            binary_reg <= {binary_reg[6:0], x};
            bit_counter <= bit_counter + 1;
            z <= x;
        end else if (first_one_received) begin
            binary_reg <= {binary_reg[6:0], ~x}; // Inverting bits for 2's complement
            bit_counter <= bit_counter + 1;
            z <= ~x;
        end else begin
            binary_reg <= {binary_reg[6:0], x};
            bit_counter <= bit_counter + 1;
            z <= x;
        end
    end
end

endmodule