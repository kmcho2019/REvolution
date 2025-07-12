module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Shift register to store the last four bits of the input stream
reg [3:0] shift_reg;

// Initialize the shift register
initial shift_reg = 0;

// Update the shift register
always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 0;
        start_shifting <= 0;
    end else begin
        shift_reg <= {data, shift_reg[3:1]};
        if(shift_reg == 4'b1101) begin
            start_shifting <= 1;
        end else if(reset) begin
            start_shifting <= 0;
        end
    end
end

endmodule