module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// 4-bit shift register to store recent history of input bit stream
reg [3:0] shift_reg;

// Initialize shift register to 0
initial shift_reg = 4'b0000;

// Shift register logic
always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000;
        start_shifting <= 0;
    end else begin
        shift_reg <= {data, shift_reg[3:1]};
        if(shift_reg == 4'b1101) begin
            start_shifting <= 1;
        end else if(reset || shift_reg!= 4'b1101) begin
            start_shifting <= 0;
        end
    end
end

endmodule