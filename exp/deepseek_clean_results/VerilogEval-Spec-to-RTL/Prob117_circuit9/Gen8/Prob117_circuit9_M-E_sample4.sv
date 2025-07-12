module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] shift_reg [0:4];
integer i;

// Initialize shift register with sequence 4,5,6,0,1
initial begin
    shift_reg[0] = 3'd4;
    shift_reg[1] = 3'd5;
    shift_reg[2] = 3'd6;
    shift_reg[3] = 3'd0;
    shift_reg[4] = 3'd1;
end

// Shift register operation
always @(posedge clk) begin
    if (!a) begin
        // Rotate right
        for (i = 4; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= shift_reg[4];
    end
end

// Output is always the first element
assign q = shift_reg[0];

endmodule