module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;
    reg [WIDTH-1:0] shift_reg;
    wire clk_enable = 1'b1; // Normally this would be a functional enable

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};
        end
        else if (clk_enable) begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

    assign out = shift_reg[WIDTH-1];

endmodule