module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] shift_reg;
reg stop;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 32'b0;
        stop <= 1'b0;
        z <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[30:0], x};
        if (~stop && x) stop <= 1'b1;
        if (~stop) z <= x;
        else z <= ~x;
    end
end

endmodule