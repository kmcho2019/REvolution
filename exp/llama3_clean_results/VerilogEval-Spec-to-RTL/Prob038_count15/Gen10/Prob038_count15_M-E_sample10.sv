module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the shift register
reg [3:0] shift_reg;

// Update the shift register on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'd0;
        q <= 4'd0;
    end else begin
        shift_reg <= {shift_reg[2:0], shift_reg[3] == 1'd1 ? 1'd0 : 1'd1};
        q <= shift_reg;
    end
end

endmodule