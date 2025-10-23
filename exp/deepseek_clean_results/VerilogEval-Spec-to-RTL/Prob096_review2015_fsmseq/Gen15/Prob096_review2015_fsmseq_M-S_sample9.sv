module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], data};
        end
    end

    assign start_shifting = (shift_reg == 3'b110) && (data == 1'b1);

endmodule