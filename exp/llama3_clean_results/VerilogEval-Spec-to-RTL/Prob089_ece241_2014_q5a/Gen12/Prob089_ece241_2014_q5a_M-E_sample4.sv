module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg;
reg [2:0] counter;
reg [7:0] complement;
reg [7:0] result;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 8'b0;
        counter <= 3'b0;
        complement <= 8'b0;
        result <= 8'b0;
    end else begin
        if (counter == 3'b0) begin
            shift_reg <= {x, 7'b0};
            counter <= counter + 1'b1;
        end else begin
            shift_reg <= {shift_reg[6:0], x};
            counter <= counter + 1'b1;
            if (counter == 3'b111) begin
                complement <= ~shift_reg + 1'b1;
                result <= complement;
                counter <= 3'b0;
            end
        end
        z <= result[7];
        result <= {result[6:0], 1'b0};
    end
end

endmodule