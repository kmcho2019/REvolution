module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
            start_shifting <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[2:0], data};
            found <= (shift_reg == 4'b1101);
            start_shifting <= found;
        end else begin
            start_shifting <= 1'b1;
        end
    end

endmodule