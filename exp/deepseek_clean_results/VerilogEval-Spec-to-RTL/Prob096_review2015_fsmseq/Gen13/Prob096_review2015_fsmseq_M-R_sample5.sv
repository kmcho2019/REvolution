module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    wire [3:0] next_shift = {shift_reg[2:0], data};
    reg [3:0] shift_reg;
    wire found = (shift_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            shift_reg <= next_shift;
            start_shifting <= found;
        end
    end

endmodule