module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    // 2-bit shift register per input bit to hold history: {previous, current}
    reg [1:0] shift_reg [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in current bit
            shift_reg[i] <= {shift_reg[i][0], in[i]};
            // Detect 0->1 transition: previous was 0 and current is 1
            pedge[i]    <= (shift_reg[i] == 2'b01);
        end
    end

endmodule