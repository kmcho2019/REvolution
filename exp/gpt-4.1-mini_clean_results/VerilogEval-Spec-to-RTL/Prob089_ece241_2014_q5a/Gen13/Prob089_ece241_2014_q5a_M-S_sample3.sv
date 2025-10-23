module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;
    reg x_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            state <= (state == 1'b0 && x_reg == 1'b1) ? 1'b1 : state;
        end
    end

    assign z = x_reg ^ state;

endmodule