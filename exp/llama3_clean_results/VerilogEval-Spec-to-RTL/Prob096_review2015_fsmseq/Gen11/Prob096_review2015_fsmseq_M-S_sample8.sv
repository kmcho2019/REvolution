module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
        start_shifting <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        
        if (shift_reg == 4'b1101) begin
            start_shifting <= 1;
        end
    end
end

endmodule