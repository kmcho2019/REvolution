module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;  // Stores last 4 bits

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (shift_reg != 4'b1101) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_shifting = (shift_reg == 4'b1101);

endmodule