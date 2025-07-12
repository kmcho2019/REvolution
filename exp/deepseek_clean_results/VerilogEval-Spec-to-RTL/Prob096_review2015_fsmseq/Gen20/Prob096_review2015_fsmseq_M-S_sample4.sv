module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // MSB acts as found flag when set

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
        end else if (!shift_reg[2]) begin
            shift_reg <= {shift_reg[1:0], data};
            if ({shift_reg, data} == 4'b1101) begin
                shift_reg <= 3'b100;  // Set MSB to mark found
            end
        end
    end

    assign start_shifting = shift_reg[2];

endmodule