module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

parameter WIDTH = 32; // Maximum input width

reg [WIDTH-1:0] shift_reg;
reg [WIDTH-1:0] count_reg;
reg first_one_seen;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        count_reg <= 0;
        first_one_seen <= 0;
        z <= 0;
    end else begin
        if (~first_one_seen) begin
            shift_reg <= {shift_reg[WIDTH-2:0], x};
            if (x) begin
                first_one_seen <= 1;
                count_reg <= WIDTH - 1;
            end
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};
            count_reg <= count_reg - 1;
            if (count_reg == 0) begin
                first_one_seen <= 0;
            end
        end
        if (first_one_seen) begin
            z <= ~shift_reg[WIDTH-1];
        end else begin
            z <= x;
        end
    end
end

endmodule