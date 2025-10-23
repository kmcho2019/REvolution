module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[1:0], data};
            found <= (shift_reg == 3'b110) && (data == 1'b1);
        end
    end

    assign start_shifting = found;

endmodule