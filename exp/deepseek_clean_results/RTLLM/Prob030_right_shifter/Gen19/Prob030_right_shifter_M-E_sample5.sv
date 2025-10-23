module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [7:0] shift_reg;
reg [2:0] wr_ptr;

initial begin
    shift_reg = 8'b0;
    wr_ptr = 3'b0;
    q = 8'b0;
end

always @(posedge clk) begin
    // Update shift register at current pointer position
    shift_reg[wr_ptr] <= d;
    
    // Update write pointer (circular buffer)
    wr_ptr <= wr_ptr + 1;
    
    // Generate parallel output with right shift effect
    q <= {shift_reg[wr_ptr], 
          shift_reg[wr_ptr+1], 
          shift_reg[wr_ptr+2],
          shift_reg[wr_ptr+3],
          shift_reg[wr_ptr+4],
          shift_reg[wr_ptr+5],
          shift_reg[wr_ptr+6],
          shift_reg[wr_ptr+7]};
end

endmodule