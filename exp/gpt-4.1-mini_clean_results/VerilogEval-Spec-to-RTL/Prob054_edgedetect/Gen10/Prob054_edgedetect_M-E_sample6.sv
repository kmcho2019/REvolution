module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [1:0] shift_reg [7:0];  // 2-bit shift registers for each bit

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= {shift_reg[i][0], in[i]};
            // shift left: oldest bit is shift_reg[i][1], newest is shift_reg[i][0]
        end
    end

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            // positive edge detected when older bit == 0 and newest bit == 1
            pedge[i] = (shift_reg[i][1] == 1'b0) && (shift_reg[i][0] == 1'b1);
        end
    end

endmodule