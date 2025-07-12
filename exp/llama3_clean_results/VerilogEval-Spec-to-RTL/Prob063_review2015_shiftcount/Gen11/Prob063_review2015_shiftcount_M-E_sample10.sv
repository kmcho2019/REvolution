module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg = 4'b0;
reg [3:0] count_reg = 4'b0;
reg [3:0] output_reg = 4'b0;

always @(posedge clk) begin
    // Shift operation
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
    
    // Decrement operation
    if (count_ena) begin
        if (count_reg == 4'b0) begin
            count_reg <= 4'b1111;  // Wrap around to maximum value
        end else begin
            count_reg <= count_reg - 1;
        end
    end
    
    // Select output based on control signals
    if (shift_ena) begin
        output_reg <= shift_reg;
    end else if (count_ena) begin
        output_reg <= count_reg;
    end
end

assign q = output_reg;

endmodule