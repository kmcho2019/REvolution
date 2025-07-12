module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg inversion_state;
reg input_bit;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        inversion_state <= 0;
        input_bit <= 0;
        z <= 0;
    end else begin
        input_bit <= x;
        if (!inversion_state && x) begin
            inversion_state <= 1;
        end
        if (inversion_state) begin
            z <= ~input_bit;
        end else begin
            z <= input_bit;
        end
    end
end

endmodule