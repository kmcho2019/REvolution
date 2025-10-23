module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] shift_reg;

// Shift register implementation
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to count=0
    end
    else if (slowena) begin
        shift_reg <= {shift_reg[8:0], shift_reg[9]};  // Circular shift
    end
end

// Priority encoder to convert one-hot to binary
assign q = (shift_reg[0] ? 4'd0 :
           shift_reg[1] ? 4'd1 :
           shift_reg[2] ? 4'd2 :
           shift_reg[3] ? 4'd3 :
           shift_reg[4] ? 4'd4 :
           shift_reg[5] ? 4'd5 :
           shift_reg[6] ? 4'd6 :
           shift_reg[7] ? 4'd7 :
           shift_reg[8] ? 4'd8 :
           shift_reg[9] ? 4'd9 :
           4'd0);

endmodule