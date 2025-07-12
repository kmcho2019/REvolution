module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] input_reg;
reg [4:0] counter;
reg start_conversion;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        input_reg <= 0;
        counter <= 0;
        start_conversion <= 0;
        z <= 0;
    end else begin
        if (counter == 0 && x == 1) begin
            start_conversion <= 1;
        end
        if (start_conversion) begin
            input_reg <= {input_reg[30:0], x};
            counter <= counter + 1;
            if (counter == 32) begin
                start_conversion <= 0;
            end
        end
        if (counter > 0) begin
            z <= ~input_reg[0] + 1'b1;
            input_reg <= {input_reg[30:0], 1'b0};
            counter <= counter - 1;
        end else if (start_conversion) begin
            z <= x;
        end else begin
            z <= 0;
        end
    end
end

endmodule